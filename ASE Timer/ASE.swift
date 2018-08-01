//
//  ASE.swift
//  ASE Timer
//
//  Created by Rahul on 7/5/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import UIKit

class ASE {
    
    var title: String!
    var description: String?
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

        if let backgroundImageDictionary = json["backgroundImageURL"] as? [String: Any] {
            let deviceName = UIDevice.deviceName.rawValue
            if let backgroundImage = backgroundImageDictionary[deviceName] as? String {
                let backgroundImageURL = URL(string: backgroundImage)
                self.backgroundImageURL = backgroundImageURL
            }
        }
        
    }
    
    func downloadBackgroundImage(_ completion: @escaping () -> Void) {
        NetworkService.shared.downloadBackgroundImage(for: self) { (image) in
            self.backgroundImage = image
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
}
