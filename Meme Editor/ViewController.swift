//
//  ViewController.swift
//  Meme Editor
//
//  Created by Edwin Vergara on 3/18/16.
//  Copyright © 2016 Edwin Vergara. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let topDefaultText = "TOP"
    let bottomDefaultText = "BOTTOM"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        self.setTextAttributesFor(topTextField)
        self.setTextAttributesFor(bottomTextField)
        
        topTextField.text = topDefaultText
        bottomTextField.text = bottomDefaultText
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func displayImagePicker() {
        self.presentImagePickerControler(delegate: self, sourceType: .PhotoLibrary)
    }
    
    @IBAction func displayCamera() {
        self.presentImagePickerControler(delegate: self, sourceType: .Camera)
    }
    
    func presentImagePickerControler(delegate delegate: protocol <UIImagePickerControllerDelegate, UINavigationControllerDelegate>, sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = delegate
        pickerController.sourceType = sourceType
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func launchActivityView() {
        let activityView = UIActivityViewController(activityItems: [], applicationActivities: nil)
        self.presentViewController(activityView, animated: true, completion: nil)
    }
    
    func setTextAttributesFor(textField: UITextField) {
        let textAttributes: [String: AnyObject] = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 44)!,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSStrokeWidthAttributeName: -1.0
        ]
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = .Center
    }
    
}

