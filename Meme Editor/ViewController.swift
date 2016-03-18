//
//  ViewController.swift
//  Meme Editor
//
//  Created by Edwin Vergara on 3/18/16.
//  Copyright © 2016 Edwin Vergara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func displayImagePicker() {
        let pickerController = UIImagePickerController()
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func displayCamera() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func launchActivityView() {
        let activityView = UIActivityViewController(activityItems: [], applicationActivities: nil)
        self.presentViewController(activityView, animated: true, completion: nil)
    }
}

