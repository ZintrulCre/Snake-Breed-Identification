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
    var image:UIImage!
    @IBOutlet weak var image_view: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image_view.image = self.image
        IdentifyImage(image: image_view.image!)
    }
    
    func IdentifyImage(image:UIImage) {
        guard let ci_image = CIImage(image: image) else {
            fatalError("Can't convert UIImage to CIImage")
        }
        
        guard let model = try?VNCoreMLModel(for: VGG16().model) else {
            fatalError("Can't load the CoreML model")
        }
        
        let request = VNCoreMLRequest(model: model) {
            (VNRequest, error) in guard let results = VNRequest.results as? [VNClassificationObservation], let most_confident = results.first else {
                fatalError("Can't regocnize image")
            }
            print (most_confident.identifier)
            print (most_confident.confidence)
            DispatchQueue.main.async {
                let breed = most_confident.identifier
                print(breed)
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
}
