//
//  InitialViewController.swift
//  ASE Timer
//
//  Created by Rahul on 3/16/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var identifier = ""

        if Date().timeIntervalSince1970 > 1553533200 {
            identifier = "WWDC2019ViewController"
        }else{
            identifier = "March2019ViewController"
        }
        
        let viewController = storyboard!.instantiateViewController(withIdentifier: identifier)
        
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
        
    }

}
