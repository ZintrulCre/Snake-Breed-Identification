//
//  CameraViewController.swift
//  WhatSnake
//
//  Created by ZintrulCre on 2019/4/1.
//  Copyright © 2019 ZintrulCre. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

import CoreMedia
import VideoToolbox

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    var capture_session: AVCaptureSession?
    var capture_device: AVCaptureDevice?
    var back_camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    var front_camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var photo_output: AVCapturePhotoOutput?
    var image:UIImage?
    
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var confidence: UILabel!
    @IBOutlet weak var camera_view: UIView!
    
    @IBAction func OnReturnButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnSwitchButtonTouchUpInside(_ sender: Any) {
        capture_session!.stopRunning()
        StartCaptureSession()
    }
    
    @IBAction fileprivate func OnImportButtonTouchUpInside(_ sender: Any) {
        let image_picker = UIImagePickerController()
        image_picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //        image_picker.allowsEditing = true
        image_picker.delegate = self
        self.present(image_picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let picked_image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.image = picked_image
        self.dismiss(animated: true)
        self.performSegue(withIdentifier: "IdentificationSegue", sender: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnCaptureButtonTouchUpInside(_ sender: Any) {
        photo_output?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        StartCaptureSession()
    }
    
    func StartCaptureSession() {
        do {
            //            initialize session and device
            capture_session = AVCaptureSession()
            capture_session?.sessionPreset = .photo
            
            //            initialize input
            capture_device = (capture_device == nil || capture_device!.position == .front) ? back_camera : front_camera
            let capture_input = try AVCaptureDeviceInput(device: capture_device!)
            capture_session?.addInput(capture_input)
            
            //            initialize output
            photo_output = AVCapturePhotoOutput()
            photo_output?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            capture_session?.addOutput(photo_output!)
            
            //            initialize layer
            let capture_preview_layer = AVCaptureVideoPreviewLayer(session: capture_session!)
            //            capture_preview_layer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
            //            capture_preview_layer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            view.layer.addSublayer(capture_preview_layer)
            capture_preview_layer.frame = view.frame
            
            //            video output
            let data_output = AVCaptureVideoDataOutput()
            data_output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_queue"))
            capture_session?.addOutput(data_output)
            
            //            start running
            capture_session?.startRunning()
        } catch {
            print(error)
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixel_buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)! else {return}
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {return}
        let request = VNCoreMLRequest(model: model) {
            (finished_request, err) in
            guard let result = finished_request.results as? [VNClassificationObservation] else {return}
            let most_confident = result.first
            DispatchQueue.main.async {
                self.identifier.text = most_confident?.identifier
                self.confidence.text = String(describing: (most_confident?.confidence))
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixel_buffer, options: [:]).perform([request])
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
