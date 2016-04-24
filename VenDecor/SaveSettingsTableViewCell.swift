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
        
        let profile = self.settingsTableVC?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileTableViewCell
        let profilePicture = profile.profilePicture.image
        // convert images to base64 string
        let imageData:NSData = UIImagePNGRepresentation(profilePicture!)!
        let base64String = imageData.base64EncodedStringWithOptions( .EncodingEndLineWithCarriageReturn )
        
        let usernameCell = self.settingsTableVC?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! SettingsTableViewCell
        let username = usernameCell.userInfoTxtField.text!
        let zipcodeCell = self.settingsTableVC?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as! SettingsTableViewCell
        let zipcode = zipcodeCell.userInfoTxtField.text!
        
        print( "username = \(username) zip = \(zipcode)" )
        
            // save post id to Firebase
            let myUserRef = Firebase(url:"https://vendecor.firebaseio.com/users/" + self.myRootRef.authData.uid )
            myUserRef.childByAppendingPath("profilePic").setValue(base64String)
            myUserRef.childByAppendingPath("username").setValue(username)
            myUserRef.childByAppendingPath("zipcode").setValue(zipcode)
        

        //TODO: update DB
        // password saved somewhere?
       /* let user = ["email" : String(self.email.text!),"username": String(self.username.text!), "zipcode" : String(self.zipcode.text!) ]
        self.myRootRef.childByAppendingPath(uid).setValue(user)
        self.dismissViewControllerAnimated(true, completion: nil)*/
    }
}
