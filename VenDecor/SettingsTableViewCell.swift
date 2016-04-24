//
//  SettingsTableViewCell.swift
//  VenDecor
//
//  Created by Rachel Frock on 4/5/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var userInfoTxtField: UITextField!
    var settingsTableVC: SettingsTableViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userInfoTxtField.delegate = self.settingsTableVC
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
