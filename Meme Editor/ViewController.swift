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
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    
    let topDefaultText = "TOP"
    let bottomDefaultText = "BOTTOM"
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.subscribeToNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        self.setTextAttributesFor(topTextField)
        self.setTextAttributesFor(bottomTextField)
        
        topTextField.text = topDefaultText
        bottomTextField.text = bottomDefaultText
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        let activityView = UIActivityViewController(activityItems: [self.generateMemedImage()], applicationActivities: nil)
        activityView.completionWithItemsHandler = { void in
            self.save();
            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
    
    func subscribeToNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        if let userInfo = notification.userInfo {
            if let keyboardSize = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
                return keyboardSize.CGRectValue().height
            }
        }
        return 0
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 && bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        } else {
            self.view.frame.origin.y = 0
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolbar.hidden = true
        navbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolbar.hidden = false
        navbar.hidden = false
        
        return memedImage
    }
    
    func save() {
        self.meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memedImage: self.generateMemedImage())
    }
    
}

