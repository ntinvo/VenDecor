//
//  MyPostsTableViewController.swift
//  VenDecor
//
//  Created by Rachel Frock on 4/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class MyPostsTableViewController: UITableViewController {

    // properties
    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    var myRootRef = Firebase( url:"https://vendecor.firebaseio.com")
    var messageTitles = [String]()
    var postImages = [String]()
    var postDates = [String]()
    var postDescriptions = [String]()
    var postPrices = [String]()
    var postConditions = [String]()
    var postStreets = [String]()
    var postStates = [String]()
    var postZipcodes = [String]()
    var postIDs = [String]()
    var claims = [Bool]()
    var messages = [NSDictionary]()
    
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
        
        let uid = myRootRef.authData.uid
        let postsRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid + "/postIDs/")
        // retrieve new posts as they are added to your database
        postsRef.observeEventType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {

                let postIDsSnap = snapshot.value as! NSDictionary
                for (_, val) in postIDsSnap {
                    let postMessagesRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + String(val ))

                    // retrieve new posts as they are added to your database
                    postMessagesRef.observeEventType(.Value, withBlock: { snapshot in
                        if !(snapshot.value is NSNull) {
                            let postID = snapshot.value.valueForKey("id") as! String
                            let messageTitle = snapshot.value.valueForKey("title") as! String
                            let postImage = snapshot.value.valueForKey("image") as! String
                            let datePosted = snapshot.value.valueForKey("datePosted") as! String
                            let description = snapshot.value.valueForKey("description") as! String
                            let price = snapshot.value.valueForKey("price") as! String
                            let condition = snapshot.value.valueForKey("condition") as! String
                            let street = snapshot.value.valueForKey("street") as! String
                            let state = snapshot.value.valueForKey("state") as! String
                            let zipcode = snapshot.value.valueForKey("zip") as! String
                            
                            if let claimed = snapshot.value.valueForKey("claimed") {
                                self.claims.append(claimed as! Bool)
                            }
                            
                            if let msgs = snapshot.value.valueForKey("messages") {
                                self.messages.append(msgs as! NSDictionary)
                            }
                            
                            self.postIDs.append(postID)
                            self.messageTitles.append( messageTitle )
                            self.postImages.append( postImage )
                            self.postDates.append( datePosted )
                            self.postDescriptions.append(description)
                            self.postPrices.append(price)
                            self.postConditions.append(condition)
                            self.postStreets.append(street)
                            self.postStates.append(state)
                            self.postZipcodes.append(zipcode)
                    
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView.reloadData()
                            }
                        }
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
        print(self.messageTitles)
        return self.messageTitles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel!.text = messageTitles[ indexPath.row ]
        let image = postImages[indexPath.row]
        let decodedData = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        cell.detailTextLabel!.text = postDates[ indexPath.row ]
        let imageView = UIImageView(image: decodedImage )
        imageView.frame = CGRectMake(0, 0, 40, 40)
        imageView.contentMode = .ScaleAspectFit
        cell.accessoryView = imageView
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
        let postTemplateVC = navVC.viewControllers.first as! PostTemplateViewController
        let indexPath = tableView.indexPathForSelectedRow!
        postTemplateVC.myPostsTableVC = self
        postTemplateVC.postID = self.postIDs[indexPath.row]
        postTemplateVC.postTitle = self.messageTitles[indexPath.row]
        postTemplateVC.postDescription = self.postDescriptions[indexPath.row]
        postTemplateVC.postPrice = self.postPrices[indexPath.row]
        postTemplateVC.postCondition = self.postConditions[indexPath.row]
        postTemplateVC.postStreet = self.postStreets[indexPath.row]
        postTemplateVC.postState = self.postStates[indexPath.row]
        postTemplateVC.postZip = self.postZipcodes[indexPath.row]
        postTemplateVC.postImageString = self.postImages[indexPath.row]
        
        if self.claims.count > 0 {
            postTemplateVC.claimed = self.claims[indexPath.row]
        }
        
        if self.messages.count > indexPath.row {
            postTemplateVC.messages = self.messages[indexPath.row]
        }
    }
}
