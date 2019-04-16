//
//  DisplayViewController.swift
//  WhatSnake
//
//  Created by ZintrulCre on 2019/4/15.
//  Copyright © 2019 ZintrulCre. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController {
    var breed: String?
    var image: UIImage!
    var snake: Snake?
    
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var type_name: UILabel!
    @IBOutlet weak var venomous: UILabel!
    @IBOutlet weak var distribution: UILabel!
    @IBOutlet weak var info: UITextView!
    
    
    @IBAction func OnSaveButtonTouchUpInside(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
        let alert = UIAlertController(title: "Photo Saved", message: "Save photo successfully!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "save", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func OnReturnButtonTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "IdentificationReturnSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image_view.image = self.image
        if self.snake != nil {
            self.type_name.text = self.snake?.name
            self.venomous.text = self.snake!.venomous ? "venomous" : "non-venomous"
            self.distribution.text = self.snake?.distribution
            self.info.text = self.snake?.description
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
