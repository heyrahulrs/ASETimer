//
//  MainViewController.swift
//  ASE Timer
//
//  Created by Rahul Sharma on 03/09/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var countdownTimerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let eventUnixTime: TimeInterval = 1505235600
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { Void in
            
            let currentUnixTime = Date().timeIntervalSince1970
            
            let timer: Double = eventUnixTime - currentUnixTime
            
            if timer <= 0 {
                self.countdownTimerLabel.text = "Watch the event live at apple.co/live"
                return
            }
            
            let days = Int(timer / 86400)
            let hours = Int(timer.truncatingRemainder(dividingBy: 86400) / 3600)
            let minutes = Int(timer.truncatingRemainder(dividingBy: 3600) / 60)
            let seconds = Int(timer.truncatingRemainder(dividingBy: 60))
            
            self.countdownTimerLabel.text = "\(days)d \(hours)h \(minutes)m \(seconds)s"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

