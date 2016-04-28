//
//  PostTemplateViewController.swift
//  VenDecor
//
//  Created by Rachel Frock on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class PostTemplateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // properties
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var descriptionTxtField: UITextView!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var conditionTxtField: UITextField!
    @IBOutlet weak var streetTxtField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTxtField: UITextField!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postItemBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var alertController: UIAlertController?
    var imagePicker: UIImagePickerController!
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    var numPosts:Int? = nil
    var homeTableViewController: HomeTableViewController? = nil
    var photoAlertController: UIAlertController?
    var myPostsTableVC: MyPostsTableViewController? = nil
    var postID: String? = nil
    var postTitle: String? = nil
    var postDescription: String? = nil
    var postPrice: String? = nil
    var postCondition: String? = nil
    var postStreet: String? = nil
    var postState: String? = nil
    var postZip: String? = nil
    var postImageString: String? = nil
    var claimed: Bool? = nil
    var messages: NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTxtField.delegate = self
        self.descriptionTxtField.delegate = self
        self.priceTxtField.delegate = self
        self.conditionTxtField.delegate = self
        self.streetTxtField.delegate = self
        self.stateTextField.delegate = self
        self.zipTxtField.delegate = self
        self.postItemBtn.layer.cornerRadius = 5
        
        self.titleTxtField.tag = 1
        self.priceTxtField.tag = 2
        self.conditionTxtField.tag = 3
        self.streetTxtField.tag = 4
        self.stateTextField.tag = 5
        self.zipTxtField.tag = 6
        
        if(self.myPostsTableVC != nil) {
            self.titleTxtField.text = self.postTitle
            self.descriptionTxtField.text = self.postDescription
            self.priceTxtField.text = self.postPrice
            self.conditionTxtField.text = self.postCondition
            self.streetTxtField.text = self.postStreet
            self.stateTextField.text = self.postState
            self.zipTxtField.text = self.postZip
            let decodedData = NSData(base64EncodedString: self.postImageString!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            self.postImage.image = UIImage(data: decodedData!)
            self.descriptionTxtField.textColor = UIColor.blackColor()
            self.postItemBtn.setTitle("Update Item", forState: .Normal)
        } else {
            self.descriptionTxtField.text = "Description"
            self.descriptionTxtField.textColor = UIColor.lightGrayColor()
        }
        
        // Register for keyboard notifications.
        let notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        // Register for when the keyboard is shown.
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        // Register for when the keyboard is hidden.
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
        self.scrollView.frame = self.view.frame
        self.scrollView.contentSize = self.view.frame.size
        
        // remove white space on top of contents
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
    
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if( textField.tag == 1 ) {
            return newLength <= 35
        } else if( textField.tag == 2 ) {
            return newLength <= 6
        } else if( textField.tag == 3 ) {
            return newLength <= 25
        } else if( textField.tag == 4 ) {
            return newLength <= 40
        } else if( textField.tag == 5 ) {
            return newLength <= 2
        } else {
            return newLength <= 5
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= 80
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // hide the keyboard
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // finish with photo source
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.postImage.image = info[ UIImagePickerControllerOriginalImage ] as? UIImage
        self.compressImage()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // compress image
    private func compressImage() {
        let rect = CGRectMake(0, 0, self.postImage.image!.size.width / 6 , self.postImage.image!.size.height / 6)
        UIGraphicsBeginImageContext(rect.size)
        self.postImage.image?.drawInRect(rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let compressedImageData = UIImageJPEGRepresentation(resizedImage, 0.1)
        self.postImage.image = UIImage(data: compressedImageData!)
        // Register for keyboard notifications.
        let notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        // Register for when the keyboard is shown.
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        // Register for when the keyboard is hidden.
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
        self.scrollView.frame = self.view.frame
        self.scrollView.contentSize = self.view.frame.size
        
        // remove white space on top of contents
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // cancel image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    // This causes the keyboard to go away also - but handles all situations when
    // the user touches anywhere outside the keyboard.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // This method is called when the user touches the Return key on the
    // keyboard. The 'textField' passed in is a pointer to the textField
    // widget the cursor was in at the time they touched the Return key on
    // the keyboard.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // called when keyboard shows
    func keyboardWillShow(notification: NSNotification) {
        // get keyboard frame from notification object.
        let info:NSDictionary = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        // pad for some space between the field and the keyboard.
        let pad:CGFloat = 5.0;
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            // set inset bottom, which will cause the scroll view to move up.
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height + pad, 0.0);
            }, completion: nil)
    }
    
    // call when keyboard hides
    func keyboardDidHide(notification: NSNotification) {
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            }, completion: nil)
    }
    
    // begin editting
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    // end editting
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

    // take/upload picture
    @IBAction func takePictureBtn(sender: AnyObject) {
        self.photoAlertController = UIAlertController(title: "Choose photo source", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet )
        let uploadPhoto = UIAlertAction(title: "Upload a Photo", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        })
        let takePhoto = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in })
        self.photoAlertController!.addAction(uploadPhoto)
        self.photoAlertController!.addAction(takePhoto)
        self.photoAlertController!.addAction(cancelAction)
        self.presentViewController(self.photoAlertController!, animated: true, completion: nil)
    }

    // post item
    @IBAction func postItem(sender: AnyObject) {
        if( self.myPostsTableVC == nil ) {
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
                    let postInfo = ["id": postID,"title" : String(self.titleTxtField.text!),"image": base64String, "description" : self.descriptionTxtField.text!, "price" : String(self.priceTxtField.text!), "condition": String(self.conditionTxtField.text!), "street": String(self.streetTxtField.text!), "state": String(self.stateTextField.text!), "zip": String(self.zipTxtField.text!), "userID" : self.myRootRef.authData.uid, "datePosted" : datePosted, "claimed" : false ]
                
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
        } else {
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
            
            // attributes
            let updatePostID = self.postID!
            let updateTitle = String(self.titleTxtField.text!)
            let updateDescription = String(self.descriptionTxtField.text!)
            let updatePrice = String(self.priceTxtField.text!)
            let updateCondition = String(self.conditionTxtField.text!)
            let updateStreet = String(self.streetTxtField.text!)
            let updateState = String(self.stateTextField.text!)
            let updateZip = String(self.zipTxtField.text!)
            
            dispatch_sync(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                
                // date posted
                let datePosted = monthStr + " " + day + ", " + year
                    
                // create post info
                
                let postInfo: NSMutableDictionary = ["id": updatePostID, "title" : updateTitle, "image": base64String, "description" : updateDescription, "price" : updatePrice, "condition": updateCondition, "street": updateStreet, "state": updateState, "zip" : updateZip, "userID" : self.myRootRef.authData.uid, "datePosted" : datePosted]
                
                // update claimed
                if (self.claimed != nil) {
                    postInfo.setValue(self.claimed!, forKey: "claimed")
                } else {
                    postInfo.setValue(false, forKey: "claimed")
                }
                
                // update messages
                if (self.messages != nil) {
                    postInfo.setValue(self.messages!, forKey: "messages")
                }
                
                // save post info to Firebase
                let myPostRef = Firebase(url:"https://vendecor.firebaseio.com/posts/")
                myPostRef.childByAppendingPath(updatePostID).setValue(postInfo)


                // reload data
                dispatch_async(dispatch_get_main_queue()) {
                    self.myPostsTableVC!.postIDs.removeAll()
                    self.myPostsTableVC!.messageTitles.removeAll()
                    self.myPostsTableVC!.postImages.removeAll()
                    self.myPostsTableVC!.postDates.removeAll()
                    self.myPostsTableVC!.postDescriptions.removeAll()
                    self.myPostsTableVC!.postPrices.removeAll()
                    self.myPostsTableVC!.postConditions.removeAll()
                    self.myPostsTableVC!.postStreets.removeAll()
                    self.myPostsTableVC!.postStates.removeAll()
                    self.myPostsTableVC!.postZipcodes.removeAll()
                    
                    let uid = self.myRootRef.authData.uid
                    let postsRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid + "/postIDs/")
                    // retrieve new posts as they are added to your database
                    postsRef.observeEventType(.Value, withBlock: { snapshot in
                        if !(snapshot.value is NSNull) {
                            
                            let postIDsSnap = snapshot.value as! NSDictionary
                            for (_, val) in postIDsSnap {
                                let postMessagesRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + String(val))
                                
                                // retrieve new posts as they are added to your database
                                postMessagesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                                    if !(snapshot.value is NSNull) {
                                        let postID = snapshot.value.valueForKey("id") as! String
                                        let messageTitle = snapshot.value.valueForKey("title") as! String
                                        let postImage = snapshot.value.valueForKey("image") as! String
                                        let datePosted = snapshot.value.valueForKey("datePosted") as! String
                                        let description = snapshot.value.valueForKey("description") as! String
                                        let price = snapshot.value.valueForKey("price") as! String
                                        let condition = snapshot.value.valueForKey("condition") as! String
                                        let street = snapshot.value.valueForKey("street") as! String
                                        let state = snapshot.value.valueForKey("state") as! String
                                        let zipcode = snapshot.value.valueForKey("zip") as! String
                                        
                                        if let claimed = snapshot.value.valueForKey("claimed") {
                                            self.myPostsTableVC!.claims.append(claimed as! Bool)
                                        }
                                        
                                        if let msgs = snapshot.value.valueForKey("messages") {
                                            self.myPostsTableVC!.messages.append(msgs as! NSDictionary)
                                        }
                                        
                                        self.myPostsTableVC!.postIDs.append(postID)
                                        self.myPostsTableVC!.messageTitles.append( messageTitle )
                                        self.myPostsTableVC!.postImages.append( postImage )
                                        self.myPostsTableVC!.postDates.append( datePosted )
                                        self.myPostsTableVC!.postDescriptions.append(description)
                                        self.myPostsTableVC!.postPrices.append(price)
                                        self.myPostsTableVC!.postConditions.append(condition)
                                        self.myPostsTableVC!.postStreets.append(street)
                                        self.myPostsTableVC!.postStates.append(state)
                                        self.myPostsTableVC!.postZipcodes.append(zipcode)
                                        
                                        dispatch_async(dispatch_get_main_queue()) {
                                            self.myPostsTableVC!.tableView.reloadData()
                                        }
                                    }
                                })
                            }
                        }
                    })

                }
            }

        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // cancel button
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
