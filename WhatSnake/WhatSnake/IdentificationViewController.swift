//
//  IdentificationViewController.swift
//  WhatSnake
//
//  Created by ZintrulCre on 2019/4/2.
//  Copyright © 2019 ZintrulCre. All rights reserved.
//

import UIKit
import CoreML
import Vision

class IdentificationViewController: UIViewController {
    var breed: String?
    var image: UIImage!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func OnCancelButtonTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "CancelSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        IdentifyImage(image: self.image!)
    }
    
    func IdentifyImage(image:UIImage) {
        guard let ci_image = CIImage(image: image) else {
            fatalError("Can't convert UIImage to CIImage")
        }
        
        guard let model = try?VNCoreMLModel(for: SnakeNet().model) else {
            fatalError("Can't load the CoreML model")
        }
        
        let request = VNCoreMLRequest(model: model) {
            (VNRequest, error) in guard let results = VNRequest.results as? [VNClassificationObservation], let most_confident = results.first else {
                fatalError("Can't regocnize image")
            }
            print (most_confident.identifier)
            print (most_confident.confidence)
            DispatchQueue.main.async {
                self.breed = most_confident.identifier
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "IdentifyingToDisplaySegue", sender: nil)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ci_image)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IdentifyingToDisplaySegue" {
            let display_view = segue.destination as! DisplayViewController
            display_view.image = self.image
            display_view.breed = self.breed
        }
    }
}
