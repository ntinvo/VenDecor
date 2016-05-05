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

    @IBOutlet weak var noMessages: UILabel!
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
        
        
//        // Testing notification
//        var dateComp = NSDateComponents()
//        dateComp.year = 2016
//        dateComp.month = 05
//        dateComp.day = 3
//        dateComp.hour = 13
//        dateComp.minute = 12
//        dateComp.timeZone = NSTimeZone.systemTimeZone()
//        
//        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
//        var date = calendar?.dateFromComponents(dateComp)
//        
//        var notification = UILocalNotification()
//        notification.category = "message"
//        notification.alertBody = "You have a new message!!!"
//        notification.fireDate = date
//        
//        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
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
                let postIDsSnap = snapshot.value as! NSDictionary
                for (key, _) in postIDsSnap {
                    let postMessagesRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + String(key))
                    
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
                                self.postsID.append(String(snapshot.value.valueForKey("id")!))
                            }
                            
                        }
                        self.tableView.reloadData()
                        if( self.messageTitles.count == 0 ) {
                            self.noMessages.text = "You do not have any messages"
                        } else {
                            self.noMessages.text = ""
                        }
                    })
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // cell's height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: (NSIndexPath!)) -> CGFloat {
        return 85
    }
    
    
    // number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageTitles.count
    }

    // returning cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel!.text = self.messageTitles[ indexPath.row ]
        cell.detailTextLabel!.text = self.lastTexts [indexPath.row ]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        return cell
    }

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
