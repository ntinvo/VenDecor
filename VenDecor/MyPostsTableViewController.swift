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

    @IBOutlet weak var noPosts: UILabel!
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
        postsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {

                let postIDsSnap = snapshot.value as! NSDictionary
                for (_, val) in postIDsSnap {
                    let postMessagesRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + String(val ))

                    // retrieve new posts as they are added to your database
                    postMessagesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
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
                                if( self.messageTitles.count == 0 ) {
                                    self.noPosts.text = "No posts have been saved"
                                } else {
                                    self.noPosts.text = ""
                                }
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

    // number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageTitles.count
    }

    // returning cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let image = postImages[indexPath.row]
        let decodedData = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        cell.detailTextLabel!.text = postDates[ indexPath.row ]
        let imageView = UIImageView(image: decodedImage )
        imageView.frame = CGRectMake(0, 0, 70, 70)
        imageView.contentMode = .ScaleAspectFit
        cell.accessoryView = imageView
        if( self.claims[ indexPath.row ] ) {
            let color = UIColor(red: 1, green: 174/255, blue: 0, alpha: 1)
            let claimText = "[CLAIMED] \r\n" + messageTitles[ indexPath.row ]
            let myMutableString = NSMutableAttributedString(string: claimText, attributes: nil)
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location:0,length:10))
            
            // set label Attribute
            cell.textLabel!.attributedText = myMutableString
            cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.textLabel!.numberOfLines = 3
            
        } else {
            cell.textLabel!.text = messageTitles[ indexPath.row ]
        }
        return cell
    }

    // cell's height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: (NSIndexPath!)) -> CGFloat {
        return 90
    }
    
    // removing
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let id = self.postIDs.removeAtIndex(indexPath.row)
            self.messageTitles.removeAtIndex(indexPath.row)
            self.postDescriptions.removeAtIndex(indexPath.row)
            self.postPrices.removeAtIndex(indexPath.row)
            self.postConditions.removeAtIndex(indexPath.row)
            self.postStreets.removeAtIndex(indexPath.row)
            self.postStates.removeAtIndex(indexPath.row)
            self.postZipcodes.removeAtIndex(indexPath.row)
            self.postImages.removeAtIndex(indexPath.row)
            if self.claims.count > 0 {
                self.claims.removeAtIndex(indexPath.row)
            }
            if self.messages.count > indexPath.row {
                self.messages.removeAtIndex(indexPath.row)
            }

            let postReference = Firebase(url: "https://vendecor.firebaseio.com/posts/" + String(id))
            postReference.removeValue()
            
            let userPostIDsRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + String(self.myRootRef.authData.uid) + "/postIDs/" + String(id))
            userPostIDsRef.removeValue()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            //reload to check if there are now no posts
        }
    }

    // in a storyboard-based application, you will often want to do a little preparation before navigation
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
