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
import CameraManager


class switchView: UIViewController, UIImagePickerControllerDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBAction func `switch`(sender: AnyObject) {
        _updateCameraDevice(cameraDevice)
    }
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var defaultCamera: AVCaptureDevicePosition?
    
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
//                cameraView.layer.addSublayer(cameraView!)
                
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
    
    
    // NEW CODE
    
    private var cameraIsSetup = false
    
    public var showErrorsToUsers = false
    
    public var showErrorBlock:(erTitle: String, erMessage: String) -> Void = { (erTitle: String, erMessage: String) -> Void in
        
    }
    
    public var cameraIsReady: Bool {
        get {
            return cameraIsSetup
        }
    }
    
    private lazy var backCameraDevice: AVCaptureDevice? = {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        return devices.filter{$0.position == .Back}.first
    }()
    
    private lazy var frontCameraDevice: AVCaptureDevice? = {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        return devices.filter{$0.position == .Front}.first
    }()
    
    public var hasFrontCamera: Bool = {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for  device in devices  {
            let captureDevice = device as! AVCaptureDevice
            if (captureDevice.position == .Front) {
                return true
            }
        }
        return false
    }()
    
    
    
    public var cameraDevice = CameraDevice.Back {
        didSet {
            if cameraIsSetup {
                if cameraDevice != oldValue {
                    _updateCameraDevice(cameraDevice)
                }
            }
        }
    }
    
    private func _deviceInputFromDevice(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let outError {
            _show(NSLocalizedString("Device setup error occured", comment:""), message: "\(outError)")
            return nil
        }
    }
    
    private func _show(title: String, message: String) {
        if showErrorsToUsers {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.showErrorBlock(erTitle: title, erMessage: message)
            })
        }
    }
    
    private func _updateCameraDevice(deviceType: CameraDevice) {
        if let validCaptureSession = captureSession {
            validCaptureSession.beginConfiguration()
            let inputs = validCaptureSession.inputs as! [AVCaptureInput]
            
            for input in inputs {
                if let deviceInput = input as? AVCaptureDeviceInput {
                    if deviceInput.device == backCameraDevice && cameraDevice == .Front {
                        validCaptureSession.removeInput(deviceInput)
                        break;
                    } else if deviceInput.device == frontCameraDevice && cameraDevice == .Back {
                        validCaptureSession.removeInput(deviceInput)
                        break;
                    }
                }
            }
            switch cameraDevice {
            case .Front:
                if hasFrontCamera {
                    if let validFrontDevice = _deviceInputFromDevice(frontCameraDevice) {
                        if !inputs.contains(validFrontDevice) {
                            validCaptureSession.addInput(validFrontDevice)
                        }
                    }
                }
            case .Back:
                if let validBackDevice = _deviceInputFromDevice(backCameraDevice) {
                    if !inputs.contains(validBackDevice) {
                        validCaptureSession.addInput(validBackDevice)
                    }
                }
            }
            validCaptureSession.commitConfiguration()
        }
    }
    
    
    // END NEW CODE
    
    
    
    
    func reloadCamera() {
        // camera loading code
//        
//        var captureDevice:AVCaptureDevice! = nil
//        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//        
//        captureSession?.stopRunning()
//        previewLayer?.removeFromSuperlayer()
//        captureSession = AVCaptureSession()
//        captureSession?.sessionPreset = AVCaptureSessionPresetHigh
//        
//        if (camera == CameraType.Back) {
//            let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
//            
//            for device in videoDevices{
//                let device = device as! AVCaptureDevice
//                if device.position == AVCaptureDevicePosition.Front {
//                    captureDevice = device
//                    break
//                }
//            }
//        } else {
//            var captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//        }
//        
//        var error: NSError?
//        
//        do {
//            
//            let input = try AVCaptureDeviceInput(device: captureDevice)
//            
//            if error == nil && captureSession!.canAddInput(input) {
//                captureSession?.addInput(input)
//                
//                
//                stillImageOutput = AVCaptureStillImageOutput()
//                stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
//                if captureSession!.canAddOutput(stillImageOutput) {
//                    captureSession!.addOutput(stillImageOutput)
//                    
//                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//                    previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
//                    previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
//                    cameraView.layer.addSublayer(previewLayer!)
//                    captureSession!.startRunning()
//                }
//            }
//            
//        }
//        catch let error as NSError {
//            NSLog("\(error), \(error.localizedDescription)")
//        }
    }
}