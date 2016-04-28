//
//  HomeTableViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 3/20/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewController: UITableViewController, UISearchBarDelegate {
    
    // properties
    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    var postings = [NSDictionary]()
    var temp: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        if revealViewController() != nil {
            self.burgerBtn.target = revealViewController()
            self.burgerBtn.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let postsRef = Firebase(url: "https://vendecor.firebaseio.com/posts")
        postsRef.observeEventType(.Value, withBlock: { snapshot in
            let posts = snapshot.value as! NSDictionary

            let enumerator = posts.keyEnumerator()
            while let key = enumerator.nextObject() {
                let post = posts[String(key)] as! NSDictionary
                self.postings.append(post)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        })
    }
    
    // sort button pressed
    @IBAction func sortBtn(sender: AnyObject) {
        for i in 0 ..< self.postings.count {
            let dict = self.postings[i]
            let stringDate = dict.valueForKey("datePosted")!
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.LongStyle
            let date = formatter.dateFromString(stringDate as! String)
            dict.setValue(date, forKey: "date")
        }
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortedResults: NSArray = (self.postings as NSArray).sortedArrayUsingDescriptors([descriptor])
        self.postings = sortedResults as! [NSDictionary]
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellid", forIndexPath: indexPath) as! HomeTableViewCell
        cell.homeTableViewController = self
        cell.cellNum = indexPath.row
        
        let dict = self.postings[indexPath.row]
        cell.title.text = String(dict.valueForKey("title")!)
        cell.itemDescription.text = String(dict.valueForKey("description")!)
        cell.price.text = "$" + String(dict.valueForKey("price")!)
        cell.condition.text = String(dict.valueForKey("condition")!)
        cell.location.text = String(dict.valueForKey("street")!) + " " + String(dict.valueForKey("state")!) + " " + String(dict.valueForKey("zip")!)
        cell.datePostedLabel.text = String( dict.valueForKey("datePosted")! )
        cell.postID = String(dict.valueForKey("id")!)
        let decodedData = NSData(base64EncodedString: String(dict.valueForKey("image")!), options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        if((dict.valueForKey("claimed") != nil && (dict.valueForKey("claimed")! as! Bool) == true)) {
            cell.claimLabel.text = "CLAIMED"
        } else {
            cell.claimLabel.text = ""
        }
        cell.postImage.image = decodedImage
        return cell
    }

    // post an item
    @IBAction func sellBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("postItem", sender: sender)
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
        
        if( segue.identifier == "message" ) {
            let navVC = segue.destinationViewController as! UINavigationController
            let messageVC = navVC.viewControllers.first as! MessageViewController
            messageVC.senderId = myRootRef.authData.uid
            messageVC.senderDisplayName = ""
            messageVC.temp = self.temp!
            let dict = self.postings[ self.temp! ]
            let uid = dict.valueForKey( "userID" ) as? String
            let postID = dict.valueForKey("id") as? String
            let postTitle = dict.valueForKey("title") as? String
            messageVC.title = postTitle!
            messageVC.receiverID = uid
            messageVC.postID = postID
            messageVC.homeTableViewController = self
        } else if (segue.identifier == "postItem") {
            let navVC = segue.destinationViewController as! UINavigationController
            let postTemplateVC = navVC.viewControllers.first as! PostTemplateViewController
            postTemplateVC.homeTableViewController = self
        }
    }
}
