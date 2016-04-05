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
        //TODO: update DB
        // password saved somewhere?
        
        
       /* let user = ["email" : String(self.email.text!),"username": String(self.username.text!), "zipcode" : String(self.zipcode.text!) ]
        self.myRootRef.childByAppendingPath(uid).setValue(user)
        self.dismissViewControllerAnimated(true, completion: nil)*/
    }
    
}
