//
//  SettingsTableViewController.swift
//  VenDecor
//
//  Created by Rachel Frock on 3/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    var userInfo: [String] = [ "USERNAME", "EMAIL", "ZIP CODE", "CHANGE PASSWORD", "" ]
    var username:String? = nil
    var email:String? = nil
    var zipcode:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//            self.usernameLabel.text = snapshot.value.valueForKey( "username" ) as? String
//            self.emailLabel.text = snapshot.value.valueForKey( "email" ) as? String
//            self.zipLabel.text = snapshot.value.valueForKey( "zipcode" ) as? String
//            self.dateJoinedLabel.text = snapshot.value.valueForKey( "datejoined" ) as? String
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataModel() {
        // get user info to fill cells
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: (NSIndexPath!)) -> CGFloat {
        
        // Toggle the cell height - alternating between rows.
        
        if( indexPath.row % 2 != 0 && indexPath.section != 4 ) {
            return 35
        } else {
           return 75
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
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
        
        print( indexPath.row )
        
        if( indexPath.section == 4 && indexPath.row == 0 ) {
            let cell = tableView.dequeueReusableCellWithIdentifier("saveCell", forIndexPath: indexPath)
            // Configure the cell...
            
            return cell
            
        } else if( (indexPath.row % 2 != 0) || indexPath.section == 4 ) {
            let cell = tableView.dequeueReusableCellWithIdentifier("fillerCell", forIndexPath: indexPath)
            // Configure the cell...
            return cell
        
        } else {
            
            //let index = indexPath.row
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cellid", forIndexPath: indexPath) as! SettingsTableViewCell
            // Configure the cell...
            
            // TODO: can we access that label? Or do we need custom cells? Or could we manually add each cell in the storyboard? 
            
            if( indexPath.section != 3 ) {
                cell.userInfoTxtField.text = "testing"
            } else {
                cell.userInfoTxtField.secureTextEntry = true
                cell.userInfoTxtField.text = "hidden"
            }
            return cell
        }
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
