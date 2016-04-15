//
//  MemeDetailViewController.swift
//  Meme Editor
//
//  Created by Edwin Vergara on 4/14/16.
//  Copyright © 2016 Edwin Vergara. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = meme.memedImage
    }
}
