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

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    
    @IBOutlet weak var burgerBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true;
        //profileImageView.frame = CGRectMake(0, 0, 50, 50)
//
//        self.btnPicture.layer.cornerRadius = self.btnPicture.frame.size.width / 2;
//        self.btnPicture.clipsToBounds = true;
        
        // navigation bar
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        if revealViewController() != nil {
            self.burgerBtn.target = revealViewController()
            self.burgerBtn.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let myRootRef = Firebase( url: "https://vendecor.firebaseio.com/users/" )
        let uid = myRootRef.authData.uid
        let userAccount = Firebase(url: "https://vendecor.firebaseio.com/users/" + uid )
        
        userAccount.observeEventType(.Value, withBlock: { snapshot in
            //self.numPosts = snapshot.value as? Int
            
            print( snapshot.value )
            self.usernameLabel.text = snapshot.value.valueForKey( "username" ) as? String
            self.emailLabel.text = snapshot.value.valueForKey( "email" ) as? String
            self.zipLabel.text = snapshot.value.valueForKey( "zipcode" ) as? String
            self.dateJoinedLabel.text = snapshot.value.valueForKey( "datejoined" ) as? String
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(img : AnyObject) {
        // change profile image
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
