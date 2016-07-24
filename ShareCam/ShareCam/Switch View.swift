//
//  switchView.swift
//  ShareCam
//
//  Created by Joseph Leiber on 7/23/16.
//  Copyright © 2016 Reduct Software. All rights reserved.
//

import Foundation
import UIKit
import Social
import AVFoundation

class switchView: UIViewController, UIImagePickerControllerDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBAction func `switch`(sender: AnyObject) {
    }
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewWillAppear(animated: Bool) {
        self.createAVSession()
        previewLayer?.frame = cameraView.bounds
    }
    
//    override func viewDidLoad() {
//        self.viewDidLoad()
//        self.createAVSession()
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        previewLayer?.frame = cameraView.bounds
    }
    
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

    var camera = CameraType.Back
    
    enum CameraType {
        case Front
        case Back
    }
    
    func reloadCamera() {
        // camera loading code
        captureSession?.stopRunning()
        previewLayer?.removeFromSuperlayer()
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        var captureDevice:AVCaptureDevice! = nil
        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if camera == CameraType.Back {
            let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
            
            for device in videoDevices{
                let device = device as! AVCaptureDevice
                if device.position == AVCaptureDevicePosition.Front {
                    captureDevice = device
                    break
                }
            }
        } else {
            var captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        }
        
        var error: NSError?
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            if error == nil && captureSession!.canAddInput(input) {
                captureSession?.addInput(input)
                
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                if captureSession!.canAddOutput(stillImageOutput) {
                    captureSession!.addOutput(stillImageOutput)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                    previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                    cameraView.layer.addSublayer(previewLayer!)
                    captureSession!.startRunning()
                }
            }
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
}