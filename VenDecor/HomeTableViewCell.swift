//
//  HomeTableViewCell.swift
//  VenDecor
//
//  Created by Tin Vo on 3/20/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class HomeTableViewCell: UITableViewCell {

    // properties
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var claimLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    var alertController: UIAlertController? = nil
    var homeTableViewController: HomeTableViewController? = nil
    var postID: String? = nil
    var cellNum: Int? = nil
    
    //var timer = NSTimer
    //var time = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector( "notification" ), userInfo: nil, repeats: true)
        
    }

    override func layoutSubviews() {
        self.postSetup()
        self.imageSetup()
    }
    
    // helper function to set up the posts
    private func postSetup() {
        self.postView.layer.masksToBounds = false
        self.postView.layer.cornerRadius = 1
        self.postView.layer.shadowOffset = CGSizeMake(CGFloat(-0.2), CGFloat(0.2))
        self.postView.layer.shadowRadius = 1
        self.postView.layer.shadowOpacity = 0.2
        let path:UIBezierPath = UIBezierPath(rect: self.postView.bounds)
        self.postView.layer.shadowPath = path.CGPath;
    }
    
    // helper function to setup the image
    private func imageSetup() {
        postImage.layer.cornerRadius = postImage.frame.size.width/2
        postImage.clipsToBounds = true
        postImage.contentMode = .ScaleAspectFill
    }
    
    // set selected
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // save button pressed
    @IBAction func saveBtn(sender: AnyObject) {
        // save post id to Firebase
        let myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
        let myUserRef = Firebase(url:"https://vendecor.firebaseio.com/users/" + myRootRef.authData.uid)
        let postIDsRef = myUserRef.childByAppendingPath("savedIDs")
        postIDsRef.childByAppendingPath(String(self.postID!)).setValue(self.postID!)
        
        // alert
        self.alertController = UIAlertController(title: "Save Item", message: "This item will be stored under Saved Posts", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
        self.alertController!.addAction(okAction)
        self.homeTableViewController!.presentViewController(self.alertController!, animated: true, completion:nil)
    }
    
    // message button pressed
    @IBAction func messageBtn(sender: AnyObject) {
        self.homeTableViewController!.temp = self.cellNum
    }
    
    // claim button pressed
    @IBAction func claimBtn(sender: AnyObject) {
//        self.sender = UIDevice.currentDevice().identifierForVendor?.UUIDString
//        
//        messages += [JSQMessage(text: "hello", sender: self.sender)]
//        messages += [JSQMessage(text: "hello", sender: "other")]
        
        
        if (self.claimLabel.text! == "") {
            let postRef = Firebase(url:"https://vendecor.firebaseio.com/posts/" + self.postID!)
            // TODO: somehow send a message??????
            //postRef.childByAppendingPath("messages" )
            //addMessage( "sender", "I have claimed this item." )
            //let msg:JSQMessage = JSQMessage(senderId: "test", displayName: "test", text: "test")
            //postRef.childByAppendingPath( "messages" ).setValue( msg )
            
            
//            let myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
//            let messageVC = MessageViewController()

//            messageVC.postID = self.postID
//            messageVC.senderId = myRootRef.authData.uid
//            messageVC.senderDisplayName = ""
//            messageVC.addMessage(myRootRef.authData.uid as String, text: "Hi, I've just claimed your item")
//            messageVC.finishSendingMessage()
            
            postRef.childByAppendingPath("claimed").setValue(true)
            self.alertController = UIAlertController(title: "Claim Item", message: "Pick up the item within 24 hours. Contact the seller for more details.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in
                self.claimLabel.text = "CLAIMED"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
            self.alertController!.addAction(okAction)
            self.alertController!.addAction(cancelAction)
            self.homeTableViewController!.presentViewController(self.alertController!, animated: true, completion:nil)
            self.homeTableViewController?.postings.removeAll()
            let postsRef = Firebase(url: "https://vendecor.firebaseio.com/posts")
            
            // Retrieve new posts as they are added to your database
            postsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                self.homeTableViewController?.postings.removeAll()
                let posts = snapshot.value as! NSDictionary
                let enumerator = posts.keyEnumerator()
                while let key = enumerator.nextObject() {
                    let post = posts[String(key)] as! NSDictionary
                    self.homeTableViewController?.postings.append(post)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.homeTableViewController?.tableView.reloadData()
                }
            })
            
            self.homeTableViewController?.tableView.reloadData()
        } else {
            
            self.alertController = UIAlertController(title: "Claim Item", message: "This item has already been claimed.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) in }
            self.alertController!.addAction(okAction)
            self.homeTableViewController!.presentViewController(self.alertController!, animated: true, completion:nil)
        }
    }
    
    
    /*func notification() {
        
        time -= 1
        
        if( time <= 0 ) {
        
        let notification = UILocalNotification()
        notification.alertAction = "hey"
        notification.alertBody = "Something claimed!"
        notification.fireDate = NSDate( timeIntervalSinceNow: 0 )
        UIApplication.sharedApplication().scheduleLocalNotification( notification )
            
            timer.invalidate()
        }
    }*/
    
}
