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
    
    var imagePicker: UIImagePickerController!
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var descriptionTxtField: UITextView!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var conditionTxtField: UITextField!
    @IBOutlet weak var streetTxtField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTxtField: UITextField!
    
    var image: UIImage? = nil
    @IBOutlet weak var postImage: UIImageView!

    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTxtField.delegate = self
        self.descriptionTxtField.delegate = self
        self.priceTxtField.delegate = self
        self.conditionTxtField.delegate = self
        self.streetTxtField.delegate = self
        self.stateTextField.delegate = self
        self.zipTxtField.delegate = self
    
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePictureBtn(sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        print("HERE")
        presentViewController(imagePicker, animated: true, completion: nil)
        //performSegueWithIdentifier( "postPicSegue", sender: sender )
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print( "chose use photo, then seque to post template" )
        
        self.postImage.image = info[ UIImagePickerControllerOriginalImage ] as? UIImage
        
        dismissViewControllerAnimated(true, completion: nil)
        
        //presentViewController(secondViewController, animated: true, completion: nil)
        
        print("after picture")
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancelled")
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    @IBAction func postItem(sender: AnyObject) {
        
        if( self.myRootRef.authData != nil ) {
            print( self.myRootRef.authData.uid )
        }
        
        //var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(postImage.image!, 0.5)!  }
        //let imageData: NSData = postImage.image.mediumQualityJPEGNSData
        
        
        //Now use image to create into NSData format
        //let imageData:NSData = UIImagePNGRepresentation(postImage.image!)!
        //let base64String = imageData.base64EncodedStringWithOptions( .EncodingEndLineWithCarriageReturn )
        
        let postInfo = ["title" : String(self.titleTxtField.text!),"image": "", "description" : self.descriptionTxtField.text!, "price" : String(self.priceTxtField.text!), "condition": String(self.conditionTxtField.text!), "street": String(self.streetTxtField.text!), "state": String(self.stateTextField.text!), "zip": String(self.zipTxtField.text!)]
        
        let myUserRef = Firebase(url:"https://vendecor.firebaseio.com/" + self.myRootRef.authData.uid )
        myUserRef.childByAppendingPath( "post" ).setValue( postInfo )
        
        
        self.alertController = UIAlertController(title: "Complete!", message: "Your item has been posted", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
            print("Ok Button Pressed 1");
            // go to home screen 
            self.performSegueWithIdentifier("backHome", sender: sender )
        }
        self.alertController!.addAction(okAction)
        
        self.presentViewController(self.alertController!, animated: true, completion:nil)
        
        print( "completed post" )
        
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

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descriptionTxtField.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func cancelBtn(sender: AnyObject) {
       /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewControllerWithIdentifier("HomeTableViewController") as! HomeTableViewController
        
        //dismissViewControllerAnimated(true, completion: nil)
        
        presentViewController(secondViewController, animated: true, completion: nil)*/
        
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
