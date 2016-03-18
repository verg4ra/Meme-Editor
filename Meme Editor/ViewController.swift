//
//  ViewController.swift
//  Meme Editor
//
//  Created by Edwin Vergara on 3/18/16.
//  Copyright © 2016 Edwin Vergara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func displayImagePicker() {
        let pickerController = UIImagePickerController()
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
}

