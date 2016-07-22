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
    
    @IBOutlet weak var capturedPhoto: UIView!
    
    var screenSize: CGRect?
    
    func setBackground() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
    }
    
    
    // This is data passed from Camera View's prepareForSegue()
    var output: UIImage?
    var labelImage: UIImage?
    var newImage: UIImage?
    
    // This should composite images for the combined view
//    func compositeImage() {
//        let bottomImage: UIImage = output!
//        let topImage: UIImage = labelImage!
//        
//        let origin: CGPoint = CGPoint(x: 13, y: 310)
//
//        let newSize = CGSizeMake(screenSize!.width, screenSize!.height)
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
//        
//        bottomImage.drawInRect(CGRect(origin: CGPointZero, size: newSize))
//        topImage.drawInRect(CGRect(origin: origin, size: newSize))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//    }
    
    
    
    
    
    
    
    // Now that we have a composite image, this will load everything and make it pretty.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
    }
    
    // Hide Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension UIImage {
    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}


