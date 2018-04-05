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

        let eventUnixTime: TimeInterval = 1528131600
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            let currentUnixTime = Date().timeIntervalSince1970
            
            let secondsUntilEvent: Double = eventUnixTime - currentUnixTime
            
            if secondsUntilEvent <= 0 {
                self.countdownTimerLabel.text = "Keynote is now streaming live."
                return
            }
            
            let days = Int(secondsUntilEvent / 86400)
            let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
            let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
            let seconds = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 60))
            
            self.countdownTimerLabel.text = "\(days)d \(hours)h \(minutes)m \(seconds)s"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

