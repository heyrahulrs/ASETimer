//
//  UIView-Extension.swift
//  ASE Timer
//
//  Created by Rahul on 3/24/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

extension UIView {
    
    func takeScreenshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { ctx in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        return image
    }
    
}
