//
//  SaveSettingsTableViewCell.swift
//  VenDecor
//
//  Created by Rachel Frock on 4/5/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class SaveSettingsTableViewCell: UITableViewCell {

    var myRootRef = Firebase( url:"https://vendecor.firebaseio.com/users" )
    var settingsTableVC: SettingsTableViewController? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func saveSettingsBtn(sender: AnyObject) {
        print( "saving settings" )
        
//        let usernameCell = self.settingsTableVC?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileTableViewCell
//        let username = usernameCell.userInfoTxtField.text!
//        let emailCell = self.settingsTableVC?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! SettingsTableViewCell
//        let email = emailCell.userInfoTxtField.text!
//        let zipcodeCell = self.settingsTableVC?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as! SettingsTableViewCell
//        let zipcode = zipcodeCell.userInfoTxtField.text!
        
        
        
        
        //TODO: update DB
        // password saved somewhere?
       /* let user = ["email" : String(self.email.text!),"username": String(self.username.text!), "zipcode" : String(self.zipcode.text!) ]
        self.myRootRef.childByAppendingPath(uid).setValue(user)
        self.dismissViewControllerAnimated(true, completion: nil)*/
    }
}
