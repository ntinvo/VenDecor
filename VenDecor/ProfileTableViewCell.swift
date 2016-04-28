//
//  ProfileTableViewCell.swift
//  VenDecor
//
//  Created by Tin Vo on 4/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit


class ProfileTableViewCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // properties
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var button: UIButton!
    var settingsTableVC: SettingsTableViewController? = nil
    var imagePicker: UIImagePickerController!
    var alertController: UIAlertController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
        self.profilePicture.clipsToBounds = true;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // take picture button
    @IBAction func takePictureBtn(sender: AnyObject) {
        self.alertController = UIAlertController(title: "Choose photo source", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet )
       
        
        let uploadPhoto = UIAlertAction(title: "Upload a Photo", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                self.settingsTableVC!.presentViewController(imagePicker, animated: true, completion: nil)
            }
        })
        let takePhoto = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .Camera
                self.settingsTableVC!.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in })
        self.alertController!.addAction(uploadPhoto)
        self.alertController!.addAction(takePhoto)
        self.alertController!.addAction(cancelAction)
        self.settingsTableVC!.presentViewController(self.alertController!, animated: true, completion: nil)
    }
    
    // finish with image picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.profilePicture.image = info[ UIImagePickerControllerOriginalImage ] as? UIImage
        self.compressImage()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // compress the image to save in Firebase
    private func compressImage() {
        let rect = CGRectMake(0, 0, self.profilePicture.image!.size.width / 6 , self.profilePicture.image!.size.height / 6)
        UIGraphicsBeginImageContext(rect.size)
        self.profilePicture.image?.drawInRect(rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let compressedImageData = UIImageJPEGRepresentation(resizedImage, 0.1)
        self.profilePicture.image = UIImage(data: compressedImageData!)
    }
    
    // cancel button for image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
