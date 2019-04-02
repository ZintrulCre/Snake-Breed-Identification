//
//  CameraViewController.swift
//  WhatSnake
//
//  Created by ZintrulCre on 2019/4/1.
//  Copyright © 2019 ZintrulCre. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    var capture_session: AVCaptureSession?
    var capture_device: AVCaptureDevice?
    var back_camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    var front_camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var photo_output: AVCapturePhotoOutput?
    var capture_preview_layer: AVCaptureVideoPreviewLayer?
    var image:UIImage?
    
    @IBOutlet weak var camera_view: UIView!
    
    @IBAction func OnReturnButtonTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "ReturnSegue", sender: nil)
    }
    
    @IBAction func OnSwitchButtonTouchUpInside(_ sender: Any) {
        capture_session!.stopRunning()
        StartCaptureSession()
    }
    
    @IBAction func OnCaptureButtonTouchUpInside(_ sender: Any) {
        photo_output?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartCaptureSession()
    }
    
    func StartCaptureSession() {
        do {
//            initialize session and device
            capture_session = AVCaptureSession()
            capture_device = (capture_device == nil || capture_device!.position == .front) ? back_camera : front_camera
            
//            initialize input and output
            let capture_input = try AVCaptureDeviceInput(device: capture_device!)
            capture_session?.addInput(capture_input)
            photo_output = AVCapturePhotoOutput()
            photo_output?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            capture_session?.addOutput(photo_output!)
            
//            initialize layer
            capture_preview_layer = AVCaptureVideoPreviewLayer(session: capture_session!)
            capture_preview_layer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            capture_preview_layer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            capture_preview_layer?.frame = camera_view.frame
            camera_view.layer.addSublayer(capture_preview_layer!)
            
            capture_session?.startRunning()
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IdentificationSegue" {
            let IdentificationView = segue.destination as! IdentificationViewController
            IdentificationView.image = self.image
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let image_data = photo.fileDataRepresentation() {
            print(image_data)
            self.image = UIImage(data:image_data)
            performSegue(withIdentifier: "IdentificationSegue", sender: nil)
        }
    }
}
