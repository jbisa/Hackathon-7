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
        sleep(2)
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
    
    @IBAction func selectPhoto(sender: AnyObject) {
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!) {
        NSLog("Did Finish Picking")
        
        if (picker.sourceType == UIImagePickerControllerSourceType.Camera) {
            var takenImage: UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            var imageData = UIImagePNGRepresentation(takenImage)
            //var imageData = UIImageJPEGRepresentation(takenImage, 100.0)
            
            if (imageData != nil) {
                // Enter URL here
                var request = NSMutableURLRequest(URL: NSURL(string:"http://76.28.86.16:5000/translate")!)
                var session = NSURLSession.sharedSession()
                
                request.HTTPMethod = "POST"
                
                var body = NSMutableData.alloc()
                
                body.appendData(imageData)
                
                request.HTTPBody = body
                
                var response: NSURLResponse? = nil
                var error: NSError? = nil
                var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
                
                var returnString = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
                
                println("returnString \(returnString)")
                
                self.sendImageAlert()
            }
            
            UIImageWriteToSavedPhotosAlbum(takenImage, nil, nil, nil)
            
            self.savedImageAlert()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if (picker.sourceType == UIImagePickerControllerSourceType.PhotoLibrary) {
            var selectedImage: UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            var imageData = UIImagePNGRepresentation(selectedImage)
            
            // Do server stuff here
            
            self.selectedImageAlert()
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func sendImageAlert() {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Image Delivered!"
        alert.message = "Your picture was delivered to the server."
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func selectedImageAlert() {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Image Selected"
        alert.message = "Are you sure you want to use this image?"
        alert.delegate = self
        alert.addButtonWithTitle("Yes")
        alert.addButtonWithTitle("No")
        alert.show()
    }
    
    func savedImageAlert() {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll."
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}



