//
//  Capture View.swift
//  ShareCam
//
//  Created by Joseph Leiber on 7/20/16.
//  Copyright © 2016 Reduct Software. All rights reserved.
//

import Foundation
import UIKit
import Social
import AVFoundation

class CaptureView: UIViewController {
    @IBOutlet weak var capturedPhoto: UIImageView!
    
    // This is data passed from Camera View's prepareForSegue()
    let background = CameraView().output
    
    // This should composite images for the combined view
    func compositeImage() {
        let bottomImage = UIImage(named: "bottom")!
        let topImage = UIImage(named: "top")!
        
        let origin: CGPoint = CGPoint(x: 13, y: 310)
        
        
        // FINISH
        let newSize = CGSizeMake(<#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        bottomImage.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        topImage.drawInRect(CGRect(origin: origin, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    // Now that we have a composite image, this will load everything and make it pretty.
    override func viewDidLoad() {
        super.viewDidLoad()
        compositeImage()
    }
}
