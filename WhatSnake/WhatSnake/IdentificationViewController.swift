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
    @IBOutlet weak var type_text: UITextView!
    @IBOutlet weak var type: UITextView!
    @IBOutlet weak var venom_text: UITextView!
    @IBOutlet weak var venomous_text: UITextView!
    @IBOutlet weak var non_venomous_text: UITextView!
    @IBOutlet weak var info_text: UITextView!
    @IBOutlet weak var loading_text: UITextView!
    
    
    
    
    
    @IBAction func OnReturnButtonTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "IdentificationReturnSegue", sender: nil)
    }
    
    @IBAction func OnSaveButtonTouchUpInside(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil)
        let alert = UIAlertController(title: "Photo Saved", message: "Save photo successfully!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "save", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type_text.isEditable = false
        type.isEditable = false
        venom_text.isEditable = false
        venomous_text.isEditable = false
        non_venomous_text.isEditable = false
        info_text.isEditable = false
        
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
