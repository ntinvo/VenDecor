//
//  ViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 3/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    // properties
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginBtn: UIButton!
    var emailAddress: UITextField? = nil
    var alertController: UIAlertController? = nil
    var forgotAlertController: UIAlertController? = nil
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

        
        let uid = myRootRef.authData.uid
        let postsRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid + "/postIDs/")
        // retrieve new posts as they are added to your database
        postsRef.observeEventType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                let postIDsSnap = snapshot.value as! NSDictionary
                for (_, val) in postIDsSnap {
                    let postMessagesRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + String(val ))
                    let postClaimedRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + String(val ) + "/claimed/")
                    var postTitle = ""
                    
                    
                    // retrieve new posts as they are added to your database
                    postMessagesRef.observeEventType(.Value, withBlock: { snapshot in
                        if !(snapshot.value is NSNull) {
                            postTitle = snapshot.value.valueForKey("title") as! String
                        }
                    })
                    
                    
                    // retrieve new posts as they are added to your database
                    postClaimedRef.observeEventType(.Value, withBlock: { snapshot in
                        if !(snapshot.value is NSNull) {
                            let date = NSDate()
                            let calendar = NSCalendar.currentCalendar()
                            let components = calendar.components([.Hour, .Minute, .Second], fromDate: date)
                            _ = components.hour
                            _ = components.minute
                            _ = components.second + 3
                            
                            
                            let notification = UILocalNotification()
                            notification.category = "claimed"
                            notification.alertBody = "Your " + postTitle + " has been claimed."
                            notification.fireDate = date
                            
                            UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        }
                    })
                }
            }
        })
        
        
        
        
        
        
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.loginBtn.layer.cornerRadius = 5
        
        // register for keyboard notifications.
        let notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        // register for when the keyboard is shown.
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        // register for when the keyboard is hidden.
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
        self.scrollView.frame = self.view.frame
        self.scrollView.contentSize = self.view.frame.size
    }

    // view appears
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // hide the keyboard
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    // return from text field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // perform segue
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        return false
    }
    
    // keyboard shows up
    func keyboardWillShow(notification: NSNotification) {
        // get keyboard frame from notification object.
        let info:NSDictionary = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        // pad for some space between the field and the keyboard.
        let pad:CGFloat = 5.0;
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height + pad, 0.0);
            }, completion: nil)
    }
    
    // keyboard hides
    func keyboardDidHide(notification: NSNotification) {
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            }, completion: nil)
    }
    
    // prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        super.prepareForSegue(segue, sender: sender)
        if( segue.identifier == "resetPassword" ) {
            let navVC = segue.destinationViewController as! UINavigationController
            let resetVC = navVC.viewControllers.first as! ResetPasswordViewController
            resetVC.viewController = self
        }
    }

    // signup button
    @IBAction func signupBtn(sender: AnyObject) {
        performSegueWithIdentifier("signup", sender: sender)
    }

    // login button
    @IBAction func loginBtn(sender: AnyObject) {
        myRootRef.authUser(emailTxtField!.text, password: passwordTxtField.text,
            withCompletionBlock: { (error, auth) in
            if error != nil {
                self.alertController = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
                self.alertController!.addAction(okAction)
                self.presentViewController(self.alertController!, animated: true, completion:nil)
            } else if(self.myRootRef.authData.providerData["isTemporaryPassword"]! as? Bool != true) {
                if error != nil {
                    self.alertController = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
                    self.alertController!.addAction(okAction)
                    self.presentViewController(self.alertController!, animated: true, completion:nil)
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                            case .InvalidEmail:
                                //TODO
                                print("Invalid email")
                            case .InvalidPassword:
                                print("Invalid password")
                                //TODO
                            default:
                                //TODO
                                print("default")
                        }
                    }
                } else {
                    self.performSegueWithIdentifier("completedLogin", sender: sender)
                }
            } else {
                self.performSegueWithIdentifier("resetPassword", sender: sender)
            }
        })
    }
    
    // reset password
    @IBAction func resetPassword(sender: AnyObject) {
        self.forgotAlertController = UIAlertController(title: "Reset Password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
            self.myRootRef.resetPasswordForUser(self.emailAddress!.text!) { (error) -> Void in }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) in }
        self.forgotAlertController!.addAction(okAction)
        self.forgotAlertController!.addAction(cancelAction)
        self.forgotAlertController!.addTextFieldWithConfigurationHandler { (textField) -> Void in
            self.emailAddress = textField
            if self.emailTxtField?.text! == "" {
                self.emailAddress?.placeholder = "Enter your email address"
            } else {
                self.emailAddress?.text = self.emailTxtField.text
            }
        }
        self.presentViewController(self.forgotAlertController!, animated: true, completion:nil)
    }
}

