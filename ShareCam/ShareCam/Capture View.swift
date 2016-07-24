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
    
    var screenSize: CGRect?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        capturedPhoto.image = output
    }
    
    
    // This is data passed from Camera View's prepareForSegue()
    var output: UIImage?
    var labelImage: UIImage?
    var newImage: UIImage?
    

    
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


