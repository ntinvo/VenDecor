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

    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    var myRootRef = Firebase( url:"https://vendecor.firebaseio.com")
    var messageTitles = [String]()
    var postImages = [String]()
    var postDates = [String]()
    
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
        
        let uid = myRootRef.authData.uid
        let postsRef = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid + "/postIDs/")
        // Retrieve new posts as they are added to your database
        postsRef.observeEventType(.Value, withBlock: { snapshot in
            print( "first" )
            print( snapshot.value)
            
            if( !snapshot.value.exists() ) {
                print( "value doesn't exist" )
                // do nothing
            }else {
                let postIDsSnap = snapshot.value as! NSDictionary
            
            
            let enumerator = postIDsSnap.keyEnumerator()
            while let key = enumerator.nextObject() {
                let postID = postIDsSnap[String(key)] as! String
                //self.postIDs.append( postID )
                
                //for post in postIDs {
                let postMessagesRef = Firebase( url: "https://vendecor.firebaseio.com/posts/" + postID )
                // Retrieve new posts as they are added to your database
                postMessagesRef.observeEventType(.Value, withBlock: { snapshot in
                    print( "second" )
                    print( snapshot.value )
                    let messageTitle = snapshot.value.valueForKey("title") as! String
                    let postImage = snapshot.value.valueForKey("image") as! String
                    let datePosted = snapshot.value.valueForKey("datePosted") as! String
                    
                    self.messageTitles.append( messageTitle )
                    self.postImages.append( postImage )
                    self.postDates.append( datePosted )
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                })
                
                 }
                
                
                
            }
            /*dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            }*/

        })
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.messageTitles.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        cell.textLabel!.text = messageTitles[ indexPath.row ]
        
        let image = postImages[indexPath.row]
        let decodedData = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        cell.imageView!.image = decodedImage
        
        cell.detailTextLabel!.text = postDates[ indexPath.row ]
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
