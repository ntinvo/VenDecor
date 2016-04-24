//
//  ProfileTableViewCell.swift
//  VenDecor
//
//  Created by Tin Vo on 4/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var button: UIButton!
    var settingsTableVC: SettingsTableViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
        self.profilePicture.clipsToBounds = true;
//        button.layer.cornerRadius = self.button.bounds.size.width / 2
//        
//        button.addTarget(self, action: #selector(ProfileTableViewCell.cameraButtonPressed), forControlEvents: .TouchUpInside)
//        button.clipsToBounds = true
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func takePictureBtn(sender: AnyObject) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self.settingsTableVC
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        print("before present")
        self.settingsTableVC!.presentViewController(imagePicker, animated: true, completion: nil)
        print("after present")
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("GOT HERE")
        self.profilePicture.image = info[ UIImagePickerControllerOriginalImage ] as? UIImage
        //self.compressImage()
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    private func compressImage() {
//        //let rect = CGRectMake(0, 0, self.postImage.image!.size.width / 6 , self.postImage.image!.size.height / 6)
//        //UIGraphicsBeginImageContext(rect.size)
//        //self.postImage.image?.drawInRect(rect)
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        let compressedImageData = UIImageJPEGRepresentation(resizedImage, 0.1)
//        //self.postImage.image = UIImage(data: compressedImageData!)
//    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancel")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
