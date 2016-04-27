//
//  SignupViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 3/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {

    // properties
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com/users")
    var alertController: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
        self.email.delegate = self
        self.zipcode.delegate = self
        self.password.delegate = self
        self.repeatPassword.delegate = self
        self.signupBtn.layer.cornerRadius = 5
    }
    
    // cancel button
    @IBAction func cancelBtn(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // sign up button
    @IBAction func signUp(sender: AnyObject) {
        if( self.password.text != self.repeatPassword.text ) {
            self.alertController = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
            self.alertController!.addAction(okAction)
            self.presentViewController(self.alertController!, animated: true, completion:nil)
        } else {
            myRootRef.createUser(email?.text, password: password?.text,
                withValueCompletionBlock: { error, result in
                    if error != nil {
                        self.alertController = UIAlertController(title: "Error", message: "Invalid email or email was already taken!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
                        self.alertController!.addAction(okAction)
                        
                        self.presentViewController(self.alertController!, animated: true, completion:nil)
                    
                        //TODO handle error here
                
                    } else {
                        let date = NSDate()
                        let calendar = NSCalendar.currentCalendar()
                        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                        let year =  String(components.year)
                        let month = components.month
                        let dateFormatter: NSDateFormatter = NSDateFormatter()
                        let months = dateFormatter.monthSymbols
                        let monthStr = months[month - 1]
                        let uid = result["uid"] as? String
                        let user = ["email" : String(self.email.text!),"username": String(self.username.text!), "zipcode" : String(self.zipcode.text!), "datejoined" : monthStr + " " + year, "numPosts": 0, "profilePic": ""]
                        self.myRootRef.childByAppendingPath(uid).setValue(user)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
            })
        }
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
        self.username.resignFirstResponder()
        self.email.resignFirstResponder()
        self.zipcode.resignFirstResponder()
        self.password.resignFirstResponder()
        self.repeatPassword.resignFirstResponder()
        return true
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
