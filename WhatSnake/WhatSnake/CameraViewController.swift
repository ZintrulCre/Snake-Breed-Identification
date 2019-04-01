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
    var capture_session = AVCaptureSession()
    var back_camera: AVCaptureDevice?
    var front_camera: AVCaptureDevice?
    var current_camera: AVCaptureDevice?
    var photo_output: AVCapturePhotoOutput?
    var capture_preview_layer: AVCaptureVideoPreviewLayer?
    var image:UIImage?
    
    @IBAction func OnReturnButtonTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "ReturnSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitializeCaptureSession()
        InitializeDevice()
        InitializeInputAndOutput()
        InitializePreviewLayer()
        StartCaptureSession()
    }
    
    func InitializeCaptureSession() {
        capture_session.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func InitializeDevice() {
        let device_discovery_session = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = device_discovery_session.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                back_camera = device
            }
            else if device.position == AVCaptureDevice.Position.front {
                front_camera = device
            }
        }
        current_camera = back_camera
    }
    
    func InitializeInputAndOutput() {
        do {
            let capture_device_input = try AVCaptureDeviceInput(device: current_camera!)
            capture_session.addInput(capture_device_input)
            photo_output = AVCapturePhotoOutput()
            photo_output?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            capture_session.addOutput(photo_output!)
        } catch {
            print(error)
        }
    }
    
    func InitializePreviewLayer() {
        capture_preview_layer = AVCaptureVideoPreviewLayer(session: capture_session)
        capture_preview_layer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        capture_preview_layer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        capture_preview_layer?.frame = self.view.frame
        self.view.layer.insertSublayer(capture_preview_layer!, at: 0)
    }
    
    func StartCaptureSession() {
        capture_session.startRunning()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "RecognitionSegue" {
//            let recognition = segue.destination as! RecognitionViewController
//            recognition.image = self.image
//        }
//    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let image_data = photo.fileDataRepresentation() {
            print(image_data)
            image = UIImage(data:image_data)
            performSegue(withIdentifier: "PreviewSegue", sender: nil)
        }
    }
}
