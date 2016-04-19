//
//  PostTemplateViewController.swift
//  VenDecor
//
//  Created by Rachel Frock on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase 

class PostTemplateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Properties
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var descriptionTxtField: UITextView!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var conditionTxtField: UITextField!
    @IBOutlet weak var streetTxtField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTxtField: UITextField!
    @IBOutlet weak var postImage: UIImageView!
    var alertController: UIAlertController?
    var imagePicker: UIImagePickerController!
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    var numPosts:Int? = nil
    var homeTableViewController: HomeTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTxtField.delegate = self
        self.descriptionTxtField.delegate = self
        self.priceTxtField.delegate = self
        self.conditionTxtField.delegate = self
        self.streetTxtField.delegate = self
        self.stateTextField.delegate = self
        self.zipTxtField.delegate = self
        
        self.descriptionTxtField.text = "Description"
        self.descriptionTxtField.textColor = UIColor.lightGrayColor()
    
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func takePictureBtn(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.postImage.image = info[ UIImagePickerControllerOriginalImage ] as? UIImage
        self.compressImage()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func compressImage() {
        let rect = CGRectMake(0, 0, self.postImage.image!.size.width / 6 , self.postImage.image!.size.height / 6)
        UIGraphicsBeginImageContext(rect.size)
        self.postImage.image?.drawInRect(rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let compressedImageData = UIImageJPEGRepresentation(resizedImage, 0.1)
        self.postImage.image = UIImage(data: compressedImageData!)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    @IBAction func postItem(sender: AnyObject) {
        if( self.myRootRef.authData != nil ) {
        }
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  String(components.year)
        let month = components.month
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let months = dateFormatter.monthSymbols
        let monthStr = months[month - 1]
        let day = String(components.day)
        
        // convert images to base64 string
        let imageData:NSData = UIImagePNGRepresentation(postImage.image!)!
        let base64String = imageData.base64EncodedStringWithOptions( .EncodingEndLineWithCarriageReturn )
        
        dispatch_sync(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            let numPostRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + self.myRootRef.authData.uid + "/numPosts")
            numPostRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                self.numPosts = snapshot.value as? Int
            
                // generate the post id
                let postID = self.myRootRef.authData.uid + "-" + String(self.numPosts!)
                
                let datePosted = monthStr + " " + day + ", " + year
                
                // create post info
                let postInfo = ["id": postID,"title" : String(self.titleTxtField.text!),"image": base64String, "description" : self.descriptionTxtField.text!, "price" : String(self.priceTxtField.text!), "condition": String(self.conditionTxtField.text!), "street": String(self.streetTxtField.text!), "state": String(self.stateTextField.text!), "zip": String(self.zipTxtField.text!), "userID" : self.myRootRef.authData.uid, "datePosted" : datePosted ]
                
                // save post id to Firebase
                let myUserRef = Firebase(url:"https://vendecor.firebaseio.com/users/" + self.myRootRef.authData.uid)
                let postIDsRef = myUserRef.childByAppendingPath("postIDs")
                postIDsRef.childByAppendingPath(String(self.numPosts!)).setValue(postID)
                
                // save post info to Firebase
                let myPostRef = Firebase(url:"https://vendecor.firebaseio.com/posts/")
                myPostRef.childByAppendingPath(postID).setValue(postInfo)
                
                // increment post number and saved
                self.numPosts! += 1
                numPostRef.setValue(self.numPosts)
                
                self.homeTableViewController?.postings.removeAll()
                self.homeTableViewController?.tableView.reloadData()
                self.homeTableViewController?.postings.removeAll()
                self.homeTableViewController?.tableView.reloadData()
            })
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    // This causes the keyboard to go away also - but handles all situations when
    // the user touches anywhere outside the keyboard.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UITextFieldDelegate delegate method
    //
    // This method is called when the user touches the Return key on the
    // keyboard. The 'textField' passed in is a pointer to the textField
    // widget the cursor was in at the time they touched the Return key on
    // the keyboard.
    //
    // From the Apple documentation: Asks the delegate if the text field
    // should process the pressing of the return button.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // A responder is an object that can respond to events and handle them.
        // Resigning first responder here means this text field will no longer be the first
        // UI element to receive an event from this apps UI - you can think of it as giving
        // up input 'focus'.
        self.titleTxtField.resignFirstResponder()
        //self.descriptionTxtField.resignFirstResponder()
        self.priceTxtField.resignFirstResponder()
        self.conditionTxtField.resignFirstResponder()
        self.streetTxtField.resignFirstResponder()
        self.stateTextField.resignFirstResponder()
        self.zipTxtField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

    /*func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descriptionTxtField.resignFirstResponder()
            return false
        }
        return true
    }*/
    
    @IBAction func cancelBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
