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
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.image != nil {
            image_view.image = self.image
        } else {
            if self.snake?.name == "Bandy Bandy" {
                self.image_view.image = #imageLiteral(resourceName: "Bandy Bandy.jpg")
            } else if self.snake?.name == "Black-Headed Python" {
                self.image_view.image = #imageLiteral(resourceName: "Black-Headed Python.jpg")
            } else if self.snake?.name == "Carpet Python" {
                self.image_view.image = #imageLiteral(resourceName: "Carpet Python.jpg")
            } else if self.snake?.name == "Coastal Taipan" {
                self.image_view.image = #imageLiteral(resourceName: "Coastal Taipan.png")
            } else if self.snake?.name == "Common Death Adder" {
                self.image_view.image = #imageLiteral(resourceName: "Common Death Adder.jpg")
            } else if self.snake?.name == "Eastern Brown Snake" {
                self.image_view.image = #imageLiteral(resourceName: "Eastern Brown Snake.png")
            } else if self.snake?.name == "Inland Taipan" {
                self.image_view.image = #imageLiteral(resourceName: "Inland Taipan.jpg")
            } else if self.snake?.name == "Lowland Copperhead" {
                self.image_view.image = #imageLiteral(resourceName: "Lowland Copperhead.png")
            } else if self.snake?.name == "Mulga Snake" {
                self.image_view.image = #imageLiteral(resourceName: "Mulga Snake.jpg")
            } else if self.snake?.name == "Red-Bellied Black Snake" {
                self.image_view.image = #imageLiteral(resourceName: "Red Bellied Black Snake.png")
            } else if self.snake?.name == "Spotted Python" {
                self.image_view.image = #imageLiteral(resourceName: "Spotted Python.jpg")
            } else if self.snake?.name == "Suta Suta" {
                self.image_view.image = #imageLiteral(resourceName: "Suta Suta.jpg")
            } else if self.snake?.name == "Tiger Snake" {
                self.image_view.image = #imageLiteral(resourceName: "Tiger Snake.png")
            } else if self.snake?.name == "Western Brown Snake" {
                self.image_view.image = #imageLiteral(resourceName: "Western Brown Snake.png")
            }
        }
        SetText()
    }
    
    func SetText() {
        if self.snake == nil {
            self.breed = self.breed!.replacingOccurrences(of: " ", with: "")
            let file = Bundle.main.path(forResource: self.breed!, ofType: "json")
            print("File", file!)
            do {
                print(self.breed!)
                let content = try String(contentsOfFile: file!, encoding: String.Encoding.utf8)
                let data = content.data(using: .utf8)!
                let snake = try JSONDecoder().decode(Snake.self, from: data)
                self.snake = snake
            } catch let error as NSError {
                print(error)
            }
            
        }
        
        self.type_name.contentMode = .scaleToFill
        self.type_name.numberOfLines = 0
        self.type_name.text = self.snake?.name
        
        self.venomous.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.venomous.text = self.snake!.venomous ? "venomous" : "non-venomous"
        self.venomous.textColor = self.snake!.venomous ? UIColor(red: 0.92, green: 0.09, blue: 0.13, alpha: 1):UIColor(red: 0.09, green: 0.61, blue: 0.64, alpha: 1)
        
        self.distribution.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.distribution.text = self.snake?.distribution
        
        self.distribution.lineBreakMode = NSLineBreakMode.byWordWrapping;
        self.distribution.numberOfLines = 0;
            
        self.info.text = self.snake?.description
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
