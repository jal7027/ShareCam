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
    
    // UIView that constitutes the background of the Camera View - directly displays content from the camera
    @IBOutlet weak var cameraView: UIView!

    
    var output: UIImage?
    
    
    // This creates the session, but does not specify the input
    var captureSession: AVCaptureSession?
    
    // This indicates that the camera output will only be still images
    var stillImageOutput: AVCaptureStillImageOutput?
    
    // This object gathers data from the camera and passes it to cameraView
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // This loads an AV Session as soon as the view loads, but before it appears
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createAVSession()
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
                    self.output = image
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "photoTaken" {
            let photo = segue.destinationViewController as! CaptureView
            photo.capturedPhoto?.image = output
        }
    }
    

}

