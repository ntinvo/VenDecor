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

    
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com/users")
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    
    var alertController: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.username.delegate = self
        self.email.delegate = self
        self.zipcode.delegate = self
        self.password.delegate = self
        self.repeatPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelBtn(sender: AnyObject) {
        //performSegueWithIdentifier("toLogin", sender: sender )
        
       self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                    
                        self.alertController = UIAlertController(title: "Error", message: "Please check the information you entered", preferredStyle: UIAlertControllerStyle.Alert)
                    
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                            //print("Ok Button Pressed 1");
                        }
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
                        let user = ["email" : String(self.email.text!),"username": String(self.username.text!), "zipcode" : String(self.zipcode.text!), "datejoined" : monthStr + " " + year, "numPosts": 0 ]
                        self.myRootRef.childByAppendingPath(uid).setValue(user)
                    
//                        self.myRootRef.authUser(self.email!.text, password: self.password.text,
//                            withCompletionBlock: { (error, auth) in })
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
        
        // A responder is an object that can respond to events and handle them.
        // Resigning first responder here means this text field will no longer be the first
        // UI element to receive an event from this apps UI - you can think of it as giving
        // up input 'focus'.
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
