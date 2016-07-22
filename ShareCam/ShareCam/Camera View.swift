//
//  Camera View.swift
//  ShareCam
//
//  Created by Joseph Leiber on 7/20/16.
//  Copyright © 2016 Reduct Software. All rights reserved.
//

import Foundation
import UIKit
import Social
import AVFoundation

class CameraView: UIViewController, UIImagePickerControllerDelegate, UINavigationBarDelegate {
    
    // Traffic Label: UILabel
    @IBOutlet weak var trafficLabel: UILabel!
    
    var newImage: UIImage?
    
    // UIView that constitutes the background of the Camera View - directly displays content from the camera
    @IBOutlet weak var cameraView: UIView!

    @IBOutlet weak var photoButton: UIButton!
    // This is the final output that can be passed to other views through prepareForSegue()
    var output: UIImage?
    lazy var labelImage: UIImage = {
        return UIImage.imageWithLabel(self.trafficLabel)
    }()
    
    // We'll use this to capture the size of the photo
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // This creates the session, but does not specify the input
    var captureSession: AVCaptureSession?
    
    // This indicates that the camera output will only be still images
    var stillImageOutput: AVCaptureStillImageOutput?
    
    // This object gathers data from the camera and passes it to cameraView
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewWillAppear(animated: Bool) {
        self.createAVSession()
        previewLayer?.frame = cameraView.bounds
    }
    
    // This loads an AV Session as soon as the view loads, but before it appears
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createAVSession()
        self.navigationController?.navigationBarHidden = true
        let labelImage = UIImage.imageWithLabel(trafficLabel)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = cameraView.bounds
        self.navigationController?.navigationBarHidden = true
    }
    
    func labSet() {
        self.trafficLabel.text = "here is a traffic label"
    }
    
    
    // This method specifies camera inpput, error handling and defines the "stillImageOutput" property.
    func createAVSession(){
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let error: NSError?
        let input : AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
            captureSession?.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if ((captureSession?.canAddOutput(stillImageOutput)) != nil){
                captureSession?.addOutput(stillImageOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                //cameraView.layer.addSublayer(cameraView!)
                
                // It works, but the camera doesn't fit the display
                cameraView.layer.addSublayer(previewLayer!)
                captureSession?.startRunning()
            }
            
        } catch _ {
            print("no capture device was found")
        }
        
    }
    
    
    // This is the image output
    @IBAction func takePhoto(sender: UIButton) {
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler:
                { (sampleBuffer, error) in
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    self.labelImage = UIImage.imageWithLabel(self.trafficLabel)
                
                    // This assigns "output" the final value of the image
                    self.output = image
                    self.compositeImage()
            })
        }
    }
    
    func compositeImage() -> UIImage {
        var bottomImage: UIImage {
            get {
                return output!
            }
        }
        let topImage: UIImage = self.labelImage
        
        let origin: CGPoint = CGPoint(x: 13, y: 310)
        
        let newSize = CGSizeMake(screenSize.width, screenSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        bottomImage.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        topImage.drawInRect(CGRect(origin: origin, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // Hide Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Here's where we attempt to pass the captured image to CaptureView with the name "output"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sendData" {
            if let photo = segue.destinationViewController as? CaptureView {
                photo.output = output
                photo.screenSize = screenSize
                photo.labelImage = labelImage
                photo.newImage = newImage
            }
        }
    }
    

}

extension UIImage {
    class func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

