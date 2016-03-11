//
//  SignupViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 3/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var zipcode: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var repeatPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
        myRootRef.createUser(email?.text, password: password?.text,
            withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    
                    // TODO: handle the error
                    
                    
                } else {
                    let uid = result["uid"] as? String
                    
                    
                    // TODO: create the user's profile here
                    
                    
                    print("Successfully created user account with uid: \(uid)")
                }
        })
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
