//
//  ResetPasswordViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 4/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var password1TxtField: UITextField!
    @IBOutlet weak var password2TxtField: UITextField!
    var alertController: UIAlertController? = nil
    var viewController: ViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password1TxtField.delegate = self
        self.password2TxtField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveBtn(sender: AnyObject) {
        if (self.password1TxtField.text != "" && self.password2TxtField.text != "" && (self.password1TxtField.text! == self.password2TxtField.text!)) {
            let ref = Firebase(url: "https://vendecor.firebaseio.com")
            let email = ref.authData.providerData["email"] as! String
            let passWord = self.viewController?.passwordTxtField.text!
            dispatch_sync(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                ref.changePasswordForUser(email, fromOld: passWord!,
                    toNew: self.password1TxtField.text!, withCompletionBlock: { error in
                    if error != nil {
                        print("Wrong")
                    } else {
                        print("Password changed successfully")
                        self.dismissViewControllerAnimated(true, completion: nil)
                        }
                })
            }
            self.viewController?.passwordTxtField.text = ""
            
        } else {
            self.alertController = UIAlertController(title: "Error", message: "Please re-check your inputs", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
            self.alertController!.addAction(okAction)
            self.presentViewController(self.alertController!, animated: true, completion:nil)
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
        self.password1TxtField.resignFirstResponder()
        self.password2TxtField.resignFirstResponder()
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
