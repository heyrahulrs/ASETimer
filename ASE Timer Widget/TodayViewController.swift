//
//  TodayViewController.swift
//  ASE Timer Widget
//
//  Created by Rahul Sharma on 03/09/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
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
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
