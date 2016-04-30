//
//  SettingsTableViewController.swift
//  VenDecor
//
//  Created by Rachel Frock on 3/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase


class SettingsTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // properties
    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    var userInfo: [String] = [ "", "USERNAME", "ZIP CODE", "" ]
    var inputUserInfoText: Dictionary<String, AnyObject> = [:]
    var username:String? = nil
    var profilePicture:UIImage? = nil
    var zipcode:String? = nil
    var usernametextField:UITextField?
    var zipcodetextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        // navigation bar
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        if revealViewController() != nil {
            self.burgerBtn.target = revealViewController()
            self.burgerBtn.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let myRootRef = Firebase( url: "https://vendecor.firebaseio.com/users/" )
        let uid = myRootRef.authData.uid
        let userAccount = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid )
        userAccount.observeEventType(.Value, withBlock: { snapshot in
            self.username = snapshot.value.valueForKey( "username" ) as? String
            self.zipcode = snapshot.value.valueForKey( "zipcode" ) as? String
            let decodedData = NSData(base64EncodedString: String(snapshot.value.valueForKey("profilePic")!), options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            self.profilePicture = UIImage(data: decodedData!)
            self.inputUserInfoText["username"] = self.username
            self.inputUserInfoText["profile"] = self.profilePicture
            self.inputUserInfoText["zipcode"] = self.zipcode
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        })
    }

    // hide the keyboard
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    

    // This method is called when the user touches the Return key on the
    // keyboard. The 'textField' passed in is a pointer to the textField
    // widget the cursor was in at the time they touched the Return key on
    // the keyboard.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.usernametextField!.resignFirstResponder()
        self.zipcodetextField!.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // cell's height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: (NSIndexPath!)) -> CGFloat {
        if(indexPath.row == 0 && indexPath.section == 0) {
          return 250
        } else if( indexPath.section == 0 && indexPath.row == 1 ) {
            return 10
        } else if( indexPath.row % 2 != 0 && indexPath.section != 3 ) {
            return 35
        } else {
           return 75
        }
    }

    // num of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    // num of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userInfo[ section ]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if( indexPath.section == 3 && indexPath.row == 0 ) {
            let cell = tableView.dequeueReusableCellWithIdentifier("saveCell", forIndexPath: indexPath) as! SaveSettingsTableViewCell
            cell.settingsTableVC = self
            return cell
            
        } else if( (indexPath.row % 2 != 0) || indexPath.section == 3 ) {
            let cell = tableView.dequeueReusableCellWithIdentifier("fillerCell", forIndexPath: indexPath)
            return cell
        
        } else if (indexPath.section == 0 && indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("profilePicture", forIndexPath: indexPath) as! ProfileTableViewCell
            if( self.profilePicture != nil ) {
                cell.profilePicture.image = self.profilePicture
            }
            cell.settingsTableVC = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cellid", forIndexPath: indexPath) as! SettingsTableViewCell
            cell.settingsTableVC = self
                if( indexPath.section == 1 ) {
                    cell.userInfoTxtField.text = username
                    cell.userInfoTxtField.delegate = self
                    self.usernametextField = cell.userInfoTxtField
                } else {
                    cell.userInfoTxtField.text = zipcode
                    cell.userInfoTxtField.delegate = self
                    self.zipcodetextField = cell.userInfoTxtField
                }
            return cell
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        //
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    // This causes the keyboard to go away also - but handles all situations when
    // the user touches anywhere outside the keyboard.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view!.endEditing(true)
    }
}
