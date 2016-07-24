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
    
    var state = CameraState.Back
    
    enum CameraState {
        case Front
        case Back
    }
    
    func switchState() {
        if state == CameraState.Back {
            state = CameraState.Front
        }
        
        else {
            state = CameraState.Back
        }
    }
    
    @IBAction func `switch`(sender: AnyObject) {
        
        if state == CameraState.Back {
        cameraManager.cameraDevice = .Front

        }
        if state == CameraState.Front {
            cameraManager.cameraDevice = .Back
        }
       switchState()
    }

    let cameraManager = CameraManager()
    
    
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var defaultCamera: AVCaptureDevicePosition?
    
    
    
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewWillAppear(animated: Bool) {
        self.createAVSession()
        previewLayer?.frame = cameraView.bounds
        cameraManager.addPreviewLayerToView(self.cameraView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        previewLayer?.frame = cameraView.bounds
        cameraManager.addPreviewLayerToView(self.cameraView)
        cameraManager.cameraDevice = .Back
    }
    
    func createAVSession(){
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetHigh
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
}