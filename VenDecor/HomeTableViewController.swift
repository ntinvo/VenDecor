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
    
    @IBOutlet weak var burgerBtn: UIBarButtonItem!
//  @IBOutlet weak var searchBar: UISearchBar!
    var myRootRef = Firebase(url:"https://vendecor.firebaseio.com")
    var postings = [NSDictionary]()
    var temp: Int? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.searchBar.delegate = self
        
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
        // Retrieve new posts as they are added to your database
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
    @IBAction func sortBtn(sender: AnyObject) {
        print( "sorted")
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "datePosted", ascending: true)
        let sortedResults: NSArray = (self.postings as NSArray).sortedArrayUsingDescriptors([descriptor])
        self.postings = sortedResults as! [NSDictionary]
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  /*  // Called when the user touches on the main view (outside the UITextField).
    // This causes the keyboard to go away also - but handles all situations when
    // the user touches anywhere outside the keyboard.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.searchBar.endEditing(true)
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
        self.searchBar.resignFirstResponder()
        return true
    }*/


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        cell.postImage.image = decodedImage

        return cell
    }

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
        } else if (segue.identifier == "postItem") {
            let navVC = segue.destinationViewController as! UINavigationController
            let postTemplateVC = navVC.viewControllers.first as! PostTemplateViewController
            postTemplateVC.homeTableViewController = self
        }
    }
}
