//
//  UIViewController-Extension.swift
//  ASE Timer
//
//  Created by Rahul on 8/12/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
}
