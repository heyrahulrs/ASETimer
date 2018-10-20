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
    
    init(json: [String: Any]) {
        
        if let title = json["title"] as? String {
            self.title = title
        }

        if let description = json["description"] as? String {
            self.description = description
        }

        if let unixTime = json["unixTime"] as? TimeInterval {
            self.unixTime = unixTime
        }
        
    }
    
    func eventInfo() -> [String: Any] {
        
        var data: [String: Any] = [:]
        
        if let eventUnixTime = unixTime {
            data["unixTime"] = eventUnixTime
        }
        
        data["title"] = title
        data["description"] = description
        
        return data
        
    }
    
}