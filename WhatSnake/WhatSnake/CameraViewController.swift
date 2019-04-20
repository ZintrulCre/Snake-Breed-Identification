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
    

    let labelHeight:CGFloat = 50.0
    
    let yolo = YOLO()
    
    var videoCapture: VideoCapture!
    var request: VNCoreMLRequest!
    var startTimes: [CFTimeInterval] = []
    
    var boundingBoxes = [BoundingBox]()
    var colors: [UIColor] = []
    
    let ciContext = CIContext()
    var resizedPixelBuffer: CVPixelBuffer?
    
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    let semaphore = DispatchSemaphore(value: 2)
    
    
    let timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let  videoPreview: UIView = {
        let view = UIView()
        return view
    }()
    
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
        
        timeLabel.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - self.labelHeight, width: UIScreen.main.bounds.size.width, height: self.labelHeight)
        videoPreview.frame = self.view.frame
        
        view.addSubview(timeLabel)
        view.addSubview(videoPreview)
        
        timeLabel.text = ""
        
        setUpBoundingBoxes()
        setUpCoreImage()
        setUpCamera()
        
        frameCapturingStartTime = CACurrentMediaTime()
        
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
    
    func setUpBoundingBoxes() {
        for _ in 0..<YOLO.maxBoundingBoxes {
            boundingBoxes.append(BoundingBox())
        }
        
        // Make colors for the bounding boxes. There is one color for each class,
        // 20 classes in total.
        for r: CGFloat in [0.1,0.2, 0.3,0.4,0.5, 0.6,0.7, 0.8,0.9, 1.0] {
            for g: CGFloat in [0.3,0.5, 0.7,0.9] {
                for b: CGFloat in [0.4,0.6 ,0.8] {
                    let color = UIColor(red: r, green: g, blue: b, alpha: 1)
                    colors.append(color)
                }
            }
        }
    }
    func setUpCoreImage() {
        let status = CVPixelBufferCreate(nil, YOLO.inputWidth, YOLO.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self as! VideoCaptureDelegate
        videoCapture.fps = 50
        weak var welf = self
        
        videoCapture.setUp(sessionPreset: AVCaptureSession.Preset.vga640x480) { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = welf?.videoCapture.previewLayer {
                    welf?.videoPreview.layer.addSublayer(previewLayer)
                    welf?.resizePreviewLayer()
                }
                
                
                // Add the bounding box layers to the UI, on top of the video preview.
                DispatchQueue.main.async {
                    guard let  boxes = welf?.boundingBoxes,let videoLayer  = welf?.videoPreview.layer else {return}
                    for box in boxes {
                        box.addToLayer(videoLayer)
                    }
                    welf?.semaphore.signal()
                }
                
                
                // Once everything is set up, we can start capturing live video.
                welf?.videoCapture.start()
                
                
                //     yolo.buffer(from: image)
                //        self.predict(pixelBuffer: self.yolo.buffer(from: image)!)
                
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    
    func predict(pixelBuffer: CVPixelBuffer) {
        // Measure how long it takes to predict a single video frame.
        let startTime = CACurrentMediaTime()
        
        // Resize the input with Core Image to 416x416.
        guard let resizedPixelBuffer = resizedPixelBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(YOLO.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(YOLO.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        ciContext.render(scaledImage, to: resizedPixelBuffer)
        
        // This is an alternative way to resize the image (using vImage):
        //if let resizedPixelBuffer = resizePixelBuffer(pixelBuffer,
        //                                              width: YOLO.inputWidth,
        //                                              height: YOLO.inputHeight)
        
        // Resize the input to 416x416 and give it to our model.
        if let boundingBoxes = try? yolo.predict(image: resizedPixelBuffer) {
            let elapsed = CACurrentMediaTime() - startTime
            showOnMainThread(boundingBoxes, elapsed)
        }
    }
    
    
    func showOnMainThread(_ boundingBoxes: [YOLO.Prediction], _ elapsed: CFTimeInterval) {
        weak var welf = self
        
        DispatchQueue.main.async {
            // For debugging, to make sure the resized CVPixelBuffer is correct.
            //var debugImage: CGImage?
            //VTCreateCGImageFromCVPixelBuffer(resizedPixelBuffer, nil, &debugImage)
            //self.debugImageView.image = UIImage(cgImage: debugImage!)
            
            welf?.show(predictions: boundingBoxes)
            
            guard  let fps = welf?.measureFPS() else{return}
            welf?.timeLabel.text = String(format: "Elapsed %.5f seconds - %.2f FPS", elapsed, fps)
            
            welf?.semaphore.signal()
        }
    }
    
    func show(predictions: [YOLO.Prediction]) {
        for i in 0..<boundingBoxes.count {
            if i < predictions.count {
                let prediction = predictions[i]
                
                // The predicted bounding box is in the coordinate space of the input
                // image, which is a square image of 416x416 pixels. We want to show it
                // on the video preview, which is as wide as the screen and has a 4:3
                // aspect ratio. The video preview also may be letterboxed at the top
                // and bottom.
                let width = view.bounds.width
                let height = width * 4 / 3
                let scaleX = width / CGFloat(YOLO.inputWidth)
                let scaleY = height / CGFloat(YOLO.inputHeight)
                let top = (view.bounds.height - height) / 2
                
                // Translate and scale the rectangle to our own coordinate system.
                var rect = prediction.rect
                rect.origin.x *= scaleX
                rect.origin.y *= scaleY
                rect.origin.y += top
                rect.size.width *= scaleX
                rect.size.height *= scaleY
                
                // Show the bounding box.
                let label = String(format: "%@ %.1f", labels[prediction.classIndex], prediction.score)
                let color = colors[prediction.classIndex]
                boundingBoxes[i].show(frame: rect, label: label, color: color)
            } else {
                boundingBoxes[i].hide()
            }
        }
    }
    
    func measureFPS() -> Double {
        // Measure how many frames were actually delivered per second.
        framesDone += 1
        let frameCapturingElapsed = CACurrentMediaTime() - frameCapturingStartTime
        let currentFPSDelivered = Double(framesDone) / frameCapturingElapsed
        if frameCapturingElapsed > 1 {
            framesDone = 0
            frameCapturingStartTime = CACurrentMediaTime()
        }
        return currentFPSDelivered
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension CameraViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // For debugging.
        //    predict(image: UIImage(named: "bridge00508")!); return
        //    semaphore.wait()
        
        weak var welf = self
        if let pixelBuffer = pixelBuffer {
            // For better throughput, perform the prediction on a background queue
            // instead of on the VideoCapture queue. We use the semaphore to block
            // the capture queue and drop frames when Core ML can't keep up.
            DispatchQueue.global().async {
                welf?.predict(pixelBuffer: pixelBuffer)
                //        self.predictUsingVision(pixelBuffer: pixelBuffer)
            }
        }
    }
}
