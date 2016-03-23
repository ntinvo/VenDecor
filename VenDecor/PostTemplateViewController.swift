//
//  PostTemplateViewController.swift
//  VenDecor
//
//  Created by Rachel Frock on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class PostTemplateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var descriptionTxtField: UITextView!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var conditionTxtField: UITextField!
    @IBOutlet weak var streetTxtField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTxtField: UITextField!
    
    var image: UIImage? = nil
    @IBOutlet weak var postImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTxtField.delegate = self
        self.descriptionTxtField.delegate = self
        self.priceTxtField.delegate = self
        self.conditionTxtField.delegate = self
        self.streetTxtField.delegate = self
        self.stateTextField.delegate = self
        self.zipTxtField.delegate = self
        
        postImage.image = image
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
