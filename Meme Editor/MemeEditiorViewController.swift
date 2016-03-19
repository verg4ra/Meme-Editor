//
//  ViewController.swift
//  Meme Editor
//
//  Created by Edwin Vergara on 3/18/16.
//  Copyright © 2016 Edwin Vergara. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Buttons
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // Image
    @IBOutlet weak var imageView: UIImageView!
    
    // Text Fields
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // Tool and Nav Bars
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    
    // Properties
    let defaultTextTop = "TOP"
    let defaultTextBottom = "BOTTOM"
    
    var meme: Meme!
    
    
    // Override Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotifications()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        shareButton.enabled = imageView.image != nil
        
        setTextAttributesFor(topTextField)
        setTextAttributesFor(bottomTextField)
        
        topTextField.text = defaultTextTop
        bottomTextField.text = defaultTextBottom
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // Text Field Functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        clearDefaultText(textField)
    }
    
    func clearDefaultText(textField: UITextField) {
        switch textField {
        case topTextField:
            if textField.text == defaultTextTop {
                textField.text = ""
            }
        case bottomTextField:
            if textField.text == defaultTextBottom {
                textField.text = ""
            }
        default:
            break
        }
    }
    
    
    // Present Album or Camera

    @IBAction func displayImagePicker() {
        presentImagePickerControler(delegate: self, sourceType: .PhotoLibrary)
    }
    
    @IBAction func displayCamera() {
        presentImagePickerControler(delegate: self, sourceType: .Camera)
    }
    
    func presentImagePickerControler(delegate delegate: protocol <UIImagePickerControllerDelegate, UINavigationControllerDelegate>, sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = delegate
        pickerController.sourceType = sourceType
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .ScaleAspectFit
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Launch Activity View Controller
    
    @IBAction func launchActivityView() {
        let activityView = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityView.completionWithItemsHandler = { void in
            self.save();
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activityView, animated: true, completion: nil)
    }
    
    
    // Text Attributes
    
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
    
    
    // Keyboard Notificatinos
    
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
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    // Create Meme
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolbar.hidden = true
        navbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
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
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memedImage: generateMemedImage())
    }
    
}

