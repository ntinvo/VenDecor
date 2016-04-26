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

    // properties
    var myRootRef = Firebase( url:"https://vendecor.firebaseio.com/users" )
    var settingsTableVC: SettingsTableViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // save settings button
    @IBAction func saveSettingsBtn(sender: AnyObject) {
        let profile = self.settingsTableVC?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ProfileTableViewCell
        let profilePicture = profile.profilePicture.image
        
        // convert images to base64 string
        let imageData:NSData = UIImagePNGRepresentation(profilePicture!)!
        let base64String = imageData.base64EncodedStringWithOptions( .EncodingEndLineWithCarriageReturn )
        
        let usernameCell = self.settingsTableVC?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! SettingsTableViewCell
        let username = usernameCell.userInfoTxtField.text!
        let zipcodeCell = self.settingsTableVC?.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as! SettingsTableViewCell
        let zipcode = zipcodeCell.userInfoTxtField.text!
        
        
        // save post id to Firebase
        let myUserRef = Firebase(url:"https://vendecor.firebaseio.com/users/" + self.myRootRef.authData.uid )
        myUserRef.childByAppendingPath("profilePic").setValue(base64String)
        myUserRef.childByAppendingPath("username").setValue(username)
        myUserRef.childByAppendingPath("zipcode").setValue(zipcode)
    }
}
