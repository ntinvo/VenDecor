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
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)

        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        
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
            //self.email = snapshot.value.valueForKey( "email" ) as? String
            
            
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

    //Somewhere else in your class
    func hideKeyboard() {
    
        tableView.endEditing(true)
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
        self.usernametextField!.resignFirstResponder()
        self.zipcodetextField!.resignFirstResponder()
        return true
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: (NSIndexPath!)) -> CGFloat {
        
        // Toggle the cell height - alternating between rows.
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return ( userInfo.count * 2 ) + 1
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userInfo[ section ]
    }

    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //print( indexPath.row )
        
        if( indexPath.section == 3 && indexPath.row == 0 ) {
            let cell = tableView.dequeueReusableCellWithIdentifier("saveCell", forIndexPath: indexPath) as! SaveSettingsTableViewCell
            // Configure the cell...
            cell.settingsTableVC = self
            return cell
            
        } else if( (indexPath.row % 2 != 0) || indexPath.section == 3 ) {
            let cell = tableView.dequeueReusableCellWithIdentifier("fillerCell", forIndexPath: indexPath)
            // Configure the cell...
            return cell
        
        } else if (indexPath.section == 0 && indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("profilePicture", forIndexPath: indexPath) as! ProfileTableViewCell
            //cell.profilePicture.image = self.profilePicture
            print( "profilePicture in DB = \(self.profilePicture)")
            if( self.profilePicture != nil ) {
                cell.profilePicture.image = self.profilePicture
            }
            cell.settingsTableVC = self
            print( "set settingsVC to self")
            return cell
        } else {
            
            //let index = indexPath.row
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cellid", forIndexPath: indexPath) as! SettingsTableViewCell
            // Configure the cell...
            
            // TODO: can we access that label? Or do we need custom cells? Or could we manually add each cell in the storyboard? 
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

    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        let indexPath = self.tableView.indexPathForSelectedRow
//        
//        //print( "indexPath = \(indexPath), section = \(indexPath?.section), row = \(indexPath!.row)" )
//    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //let cell = tableView.dequeueReusableCellWithIdentifier("cellid", forIndexPath: indexPath!) as! SettingsTableViewCell
        
        //self.inputUserInfoText.append(textField.text!)
        //print(self.inputUserInfoText)
        
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    // This causes the keyboard to go away also - but handles all situations when
    // the user touches anywhere outside the keyboard.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view!.endEditing(true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
