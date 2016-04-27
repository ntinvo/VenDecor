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
    
    @IBAction func testing(sender: AnyObject) {
        self.performSegueWithIdentifier("testing", sender: sender)
    }
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginBtn: UIButton!
    
    var emailAddress: UITextField? = nil
    
    var alertController: UIAlertController? = nil
    var forgotAlertController: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.loginBtn.layer.cornerRadius = 5
        
//        self.emailTxtField.frame = 500
//        self.passwordTxtField.frame = 500
        
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
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    // This causes the keyboard to go away also - but handles all situations when
    // the user touches anywhere outside the keyboard.
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    // hide the keyboard
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        self.emailTxtField.resignFirstResponder()
//        self.passwordTxtField.resignFirstResponder()
        return true
    }
    
//    // UITextFieldDelegate delegate method
//    //
//    // This method is called when the user touches the Return key on the
//    // keyboard. The 'textField' passed in is a pointer to the textField
//    // widget the cursor was in at the time they touched the Return key on
//    // the keyboard.
//    //
//    // From the Apple documentation: Asks the delegate if the text field
//    // should process the pressing of the return button.
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        
//        // A responder is an object that can respond to events and handle them.
//        // Resigning first responder here means this text field will no longer be the first
//        // UI element to receive an event from this apps UI - you can think of it as giving
//        // up input 'focus'.
//        self.emailTxtField.resignFirstResponder()
//        self.passwordTxtField.resignFirstResponder()
//        return true
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signupBtn(sender: AnyObject) {
        performSegueWithIdentifier("signup", sender: sender)
    }

    @IBAction func loginBtn(sender: AnyObject) {
        myRootRef.authUser(emailTxtField!.text, password: passwordTxtField.text,
            withCompletionBlock: { (error, auth) in
                
            if(self.myRootRef.authData.providerData["isTemporaryPassword"]! as? Bool != true) {
                
                if error != nil {
                    self.alertController = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                        print("Ok Button Pressed 1");
                    }
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
    
    @IBAction func resetPassword(sender: AnyObject) {
        //myRootRef.resetPasswordForUser(email: r_frock@yahoo.com", withCompletionBlock: ((NSError!) -> Void)! )
//        let email: String? = nil
        
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
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        return false
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        // Get keyboard frame from notification object.
        let info:NSDictionary = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        // Pad for some space between the field and the keyboard.
        let pad:CGFloat = 5.0;
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            // Set inset bottom, which will cause the scroll view to move up.
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height + pad, 0.0);
            }, completion: nil)
    }
    
    func keyboardDidHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            // Restore starting insets.
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            }, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        super.prepareForSegue(segue, sender: sender)
        if( segue.identifier == "resetPassword" ) {
            let navVC = segue.destinationViewController as! UINavigationController
            let resetVC = navVC.viewControllers.first as! ResetPasswordViewController
            resetVC.viewController = self
        }
    }
}

