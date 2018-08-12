//
//  ASE.swift
//  ASE Timer
//
//  Created by Rahul on 7/5/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import UIKit

class ASE {
    
    var title: String = ""
    var description: String = ""
    var unixTime: TimeInterval?
    
    var backgroundImageURL: URL?
    var backgroundImage: UIImage?
    
    init(json: [String: Any]) {
        
        if let title = json["title"] as? String {
            self.title = title
        }

        if let description = json["description"] as? String {
            self.description = description
        }

        if let unixTime = json["eventUnixTime"] as? TimeInterval {
            self.unixTime = unixTime
        }

        if let dictionary = json["backgroundImageURL"] as? [String: Any] {
            
            let deviceName = UIDevice.deviceName.rawValue
            
            if let backgroundImage = dictionary[deviceName] as? String {
                let backgroundImageURL = URL(string: backgroundImage)
                self.backgroundImageURL = backgroundImageURL
            }
            
        }
        
        if let backgroundImageData = json["backgroundImageData"] as? Data {
            let image = UIImage(data: backgroundImageData)
            self.backgroundImage = image
        }
        
    }
    
    func downloadBackgroundImage(_ completion: @escaping () -> Void) {
        
        if let _ = backgroundImage {
            completion()
        }
        
        let deviceName = UIDevice.deviceName.rawValue

        NetworkService.shared.downloadBackgroundImage(for: self) { (image) in
            self.backgroundImage = image
            DispatchQueue.main.async {
                completion()
            }
        }
        
        print("Finished downloading background image for device \(deviceName)")
        
    }
    
    func eventInfo() -> [String: Any] {
        
        var data: [String: Any] = [:]
        
        if let backgroundImage = backgroundImage {
            
            if let imageData = backgroundImage.jpegData(compressionQuality: 1.0) {
                data["backgroundImageData"] = imageData
            }
            
        }
        
        if let eventUnixTime = unixTime {
            data["eventUnixTime"] = eventUnixTime
        }
        
        data["title"] = title
        data["description"] = description
        
        return data
        
    }
    
}
