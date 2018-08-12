//
//  URL-Extension.swift
//  ASE Timer
//
//  Created by Rahul on 8/12/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import Foundation

extension URL {
    
    init(staticString: StaticString) {
        self.init(string: "\(staticString)")!
    }
    
}
