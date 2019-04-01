//
//  ViewController.swift
//  WhatSnake
//
//  Created by ZintrulCre on 2019/4/1.
//  Copyright © 2019 ZintrulCre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func OnCameraButtonTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "CameraSegue", sender: nil)
    }
    

}

