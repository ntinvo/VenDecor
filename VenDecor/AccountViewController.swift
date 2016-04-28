//
//  AccountViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 3/18/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    // properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        self.deleteAccountBtn.layer.cornerRadius = 5
        
        // navigation bar
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        if revealViewController() != nil {
            self.burgerBtn.target = revealViewController()
            self.burgerBtn.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        let myRootRef = Firebase( url: "https://vendecor.firebaseio.com/users/" )
        let uid = myRootRef.authData.uid
        let userAccount = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid )
        
        userAccount.observeEventType(.Value, withBlock: { snapshot in
            if( String(snapshot.value.valueForKey("profilePic")!) != "" ) {
                let decodedData = NSData(base64EncodedString: String(snapshot.value.valueForKey("profilePic")!), options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                self.profileImageView.image = UIImage(data: decodedData!)
            }
            self.usernameLabel.text = snapshot.value.valueForKey( "username" ) as? String
            self.emailLabel.text = snapshot.value.valueForKey( "email" ) as? String
            self.zipLabel.text = snapshot.value.valueForKey( "zipcode" ) as? String
            self.dateJoinedLabel.text = snapshot.value.valueForKey( "datejoined" ) as? String
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imageTapped(img : AnyObject) {
        //
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
