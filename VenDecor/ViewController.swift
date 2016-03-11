//
//  ViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 3/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")

    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Write data to Firebase
        myRootRef.setValue("Do you have data? You'll love Firebase.")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        // 1
//        
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
                if error != nil {
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                            case .InvalidEmail:
                                //TODO
                                print("")
                            case .InvalidPassword:
                                print("")
                                //TODO
                            default:
                                //TOOD
                                print("")
                        }
                    }
                } else {
                    print("sucessfully loggedin")
                }
        })
        

    }
    
    
}

