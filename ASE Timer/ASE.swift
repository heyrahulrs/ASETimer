//
//  ASE.swift
//  ASE Timer
//
//  Created by Rahul on 7/5/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import Foundation

class ASE {
    
    var title: String!
    var description: String?
    var unixTime: TimeInterval?
    
    var backgroundImageURL: URL?
    
    init(json: [String: Any]) {
        
        guard let title = json["title"] as? String else { return }
        self.title = title

        guard let description = json["description"] as? String else { return }
        self.description = description

        guard let unixTime = json["eventUnixTime"] as? TimeInterval else { return }
        self.unixTime = unixTime

        guard let backgroundImage = json["backgroundImageURL"] as? String,
            let backgroundImageURL = URL(string: backgroundImage) else { return }
        self.backgroundImageURL = backgroundImageURL
        
    }
    
    func downloadBackgroundImage(completion: () -> ()) {
        //DOWNLOAD BACKGROUND IMAGE
    }
    
}
