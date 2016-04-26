//
//  MyMessagesTableViewController.swift
//  VenDecor
//
//  Created by Rachel Frock on 4/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class MyMessagesTableViewController: UITableViewController {

    // properties
    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    var lastTexts = [String]()
    var messageTitles = [String]()
    var postsID = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lastTexts.removeAll()
        self.messageTitles.removeAll()
        self.postsID.removeAll()
        
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
        
        let uid = myRootRef.authData.uid
        let postsRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid + "/postIDs/")
        // Retrieve new posts as they are added to your database
        postsRef.observeEventType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                let postIDsSnap = snapshot.value as! NSArray
                for postID in 0...(postIDsSnap.count - 1) {
                    
                    let postMessagesRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + String(postIDsSnap[postID]))
                    
                    // Retrieve new posts as they are added to your database
                    postMessagesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        if !(snapshot.value is NSNull) {
                            let postTitle = snapshot.value.valueForKey("title")!
                            let messages = snapshot.value.valueForKey("messages")
                            if messages != nil {
                                let msgDict = messages as! NSDictionary
                                let sortedKeys = (msgDict.allKeys as! [String]).sort(<)
                                let lastKey = sortedKeys[(sortedKeys.count - 1)]
                                let lastText = msgDict.valueForKey(lastKey)!["text"]!
                                self.messageTitles.append(postTitle as! String)
                                self.lastTexts.append(lastText as! String)
                                self.postsID.append(String(postIDsSnap[postID]))
                            }
                        }
                        self.tableView.reloadData()
                    })
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTitles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel!.text = self.messageTitles[ indexPath.row ]
        cell.detailTextLabel!.text = self.lastTexts [indexPath.row ]
        
        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navVC = segue.destinationViewController as! UINavigationController
        let messageVC = navVC.viewControllers.first as! MessageViewController
        let indexPath = tableView.indexPathForSelectedRow!
        messageVC.postID = self.postsID[indexPath.row]
        messageVC.senderId = myRootRef.authData.uid
        messageVC.senderDisplayName = ""
        messageVC.myMessagesViewController = self
    }
 

}
