//
//  ViewController.swift
//  Hackathon 7
//
//  Created by Jay Bisa on 2/6/15.
//  Copyright (c) 2015 Veracode. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var cameraView: UIImageView!
    
    override func viewDidLoad() {
        sleep(1)
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            var mediaTypes: Array<AnyObject> = [kUTTypeImage]
            picker.mediaTypes = mediaTypes
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            NSLog("No Camera")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!) {
        NSLog("Did Finish Picking")
        
        
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera) {
            var imageToSave: UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            
            self.savedImageAlert()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func savedImageAlert() {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}



