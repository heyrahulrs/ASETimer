//
//  ASE.swift
//  ASE Timer
//
//  Created by Rahul on 7/5/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import Foundation

struct ASE {
    
    var title: String
    var description: String
    var unixTime: TimeInterval?
    
    var hashtag: String {
        if title == "Apple Special Event" {
            return "#AppleEvent"
        }
        return "#" + title.replacingOccurrences(of: " ", with: "")
    }
    
    init(title: String, description: String, unixTime: TimeInterval?) {
        self.title = title
        self.description = description
        self.unixTime = unixTime
    }
    
}
