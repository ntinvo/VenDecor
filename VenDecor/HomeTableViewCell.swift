//
//  HomeTableViewCell.swift
//  VenDecor
//
//  Created by Tin Vo on 3/20/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    var homeTableViewController: HomeTableViewController? = nil
    
    /*
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 1; // if you like rounded corners
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f); //%%% this shadow will hang slightly down and to the right
    self.cardView.layer.shadowRadius = 1; //%%% I prefer thinner, subtler shadows, but you can play with this
    self.cardView.layer.shadowOpacity = 0.2; //%%% same thing with this, subtle is better for me
    
    //%%% This is a little hard to explain, but basically, it lowers the performance required to build shadows.  If you don't use this, it will lag
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
    
    self.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1]; //%%% I prefer choosing colors programmatically than on the storyboard
    
    
    -(void)imageSetup
    {
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    _profileImage.clipsToBounds = YES;
    _profileImage.contentMode = UIViewContentModeScaleAspectFit;
    _profileImage.backgroundColor = [UIColor whiteColor];
    }
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    // Initialization code
    }
    return self;
    
    */
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }



    override func layoutSubviews() {
        self.postSetup()
        self.imageSetup()
    }
    
    private func postSetup() {
        self.postView.layer.masksToBounds = false
        self.postView.layer.cornerRadius = 1
        self.postView.layer.shadowOffset = CGSizeMake(CGFloat(-0.2), CGFloat(0.2))
        self.postView.layer.shadowRadius = 1
        self.postView.layer.shadowOpacity = 0.2
        let path:UIBezierPath = UIBezierPath(rect: self.postView.bounds)
        self.postView.layer.shadowPath = path.CGPath;
    }
    
    private func imageSetup() {
        postImage.layer.cornerRadius = postImage.frame.size.width/2
        postImage.clipsToBounds = true
        postImage.contentMode = .ScaleAspectFill
        postImage.backgroundColor = UIColor.whiteColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func saveBtn(sender: AnyObject) {
        print("save")
    }
    
    
    @IBAction func messageBtn(sender: AnyObject) {
        self.homeTableViewController!.performSegueWithIdentifier("message", sender: sender)
    }
    
    
    @IBAction func claimBtn(sender: AnyObject) {
        print("claim")
        
    }
    
}
