//
//  UIDevice-Extension.swift
//  ASE Timer
//
//  Created by Rahul on 8/1/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import UIKit
import AVFoundation

extension UIDevice {
    
    enum DeviceName: String {
        case iPhone4S = "iPhone4S"
        case iPhoneSE = "iPhoneSE"
        case iPhone8 = "iPhone8"
        case iPhone8Plus = "iPhone8Plus"
        case iPhoneXS = "iPhoneXS"
        case iPhoneXSMax = "iPhoneXSMax"
        case iPhoneXR = "iPhoneXR"
        case iPad = "iPad"
        case unknown = "UnknownDevice"
    }
    
    static var deviceName: DeviceName {
        
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4S
        case 1136:
            return .iPhoneSE
        case 1334:
            return .iPhone8
        case 1792:
            return .iPhoneXR
        case 1920, 2208:
            return .iPhone8Plus
        case 2436:
            return .iPhoneXS
        case 2688:
            return .iPhoneXSMax
        case 2048, 2224, 2732:
            return .iPad
        default:
            return .unknown
        }
        
    }
    
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}
