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
                    let user = ["email" : String(self.email.text!),"username": String(self.username.text!), "zipcode" : String(self.zipcode.text!), "datejoined" : monthStr + " " + year]
                    self.myRootRef.childByAppendingPath(uid).setValue(user)
                }
        })
        
        performSegueWithIdentifier("completedSignup", sender: sender)
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
