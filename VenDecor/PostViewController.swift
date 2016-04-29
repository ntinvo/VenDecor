//
//  PostViewController.swift
//  VenDecor
//
//  Created by Tin Vo on 4/29/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    // properties
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postPrice: UILabel!
    @IBOutlet weak var postLocation: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var postTitleString: String? = nil
    var postPriceString: String? = nil
    var postLocationString: String? = nil
    var imageString: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        let logo = UIImage(named: "Sample.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        self.postTitle.text = self.postTitleString
        self.postPrice.text = self.postPriceString
        self.postLocation.text = self.postLocationString
        let decodedData = NSData(base64EncodedString: self.imageString!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        self.imageView.image = UIImage(data: decodedData!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // message button
    @IBAction func messageBtn(sender: AnyObject) {
        
    }
    
    // claim button
    @IBAction func claimBtn(sender: AnyObject) {
        
    }
    
    // cancel button
    @IBAction func cancelBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
