//
//  SavedPostsTableViewController.swift
//  VenDecor
//
//  Created by Rachel Frock on 4/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class SavedPostsTableViewController: UITableViewController {

    @IBOutlet weak var noPostsLabel: UILabel!
    // properties
    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    var myRootRef = Firebase( url:"https://vendecor.firebaseio.com")
    var messageTitles = [String]()
    var postImages = [String]()
    var postDates = [String]()
    var postPrices = [String]()
    var postLocations = [String]()
    var postIDs = [String]()
    var claims = [Bool]()
    
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
        let postsRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid + "/savedIDs/")
        // Retrieve new posts as they are added to your database
        postsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !(snapshot.value is NSNull) {
                let postIDsSnap = snapshot.value as! NSDictionary
                for (key, _) in postIDsSnap {
                    let postMessagesRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + String(key))
                
                    // Retrieve new posts as they are added to your database
                    postMessagesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        if !(snapshot.value is NSNull) {
                            self.messageTitles.append( snapshot.value.valueForKey("title") as! String )
                            self.postImages.append( snapshot.value.valueForKey("image") as! String )
                            self.postDates.append( snapshot.value.valueForKey("datePosted") as! String )
                            self.postPrices.append( snapshot.value.valueForKey("price") as! String )
                            self.postLocations.append( String(snapshot.value.valueForKey("street")!) + String(snapshot.value.valueForKey("city")!) + String(snapshot.value.valueForKey("state")!) + " " + String(snapshot.value.valueForKey("zip")!))
                            self.postIDs.append(snapshot.value.valueForKey("id") as! String)
                            self.claims.append( snapshot.value.valueForKey( "claimed" ) as! Bool )
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView.reloadData()
                                if( self.messageTitles.count == 0 ) {
                                    self.noPostsLabel.text = "You have not saved any posts"
                                } else {
                                    self.noPostsLabel.text = ""
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

    // number of section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageTitles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let image = postImages[indexPath.row]
        let decodedData = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        cell.detailTextLabel!.text = postDates[ indexPath.row ]
        let imageView = UIImageView(image: decodedImage )
        imageView.frame = CGRectMake(0, 0, 70, 70)
        imageView.contentMode = .ScaleAspectFit
        if( self.claims[indexPath.row] ) {
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
        cell.accessoryView = imageView
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.messageTitles.removeAtIndex(indexPath.row)
            self.postImages.removeAtIndex(indexPath.row)
            self.postDates.removeAtIndex(indexPath.row)
            self.postPrices.removeAtIndex(indexPath.row)
            self.postLocations.removeAtIndex(indexPath.row)
            let id = self.postIDs.removeAtIndex(indexPath.row)
            let userPostIDsRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + String(self.myRootRef.authData.uid) + "/savedIDs/" + String(id))
            userPostIDsRef.removeValue()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //reload to check if there are now no posts
        }
    }
    
    // cell's height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: (NSIndexPath!)) -> CGFloat {
        return 90
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navVC = segue.destinationViewController as! UINavigationController
        let postVC = navVC.viewControllers.first as! PostViewController
        let indexPath = tableView.indexPathForSelectedRow!
        postVC.postTitleString = self.messageTitles[indexPath.row]
        postVC.postPriceString = "$" + self.postPrices[indexPath.row]
        postVC.postLocationString = self.postLocations[indexPath.row]
        postVC.imageString = self.postImages[indexPath.row]
        postVC.postID = self.postIDs[indexPath.row]
        postVC.claimed = self.claims[ indexPath.row ]
    }
}
