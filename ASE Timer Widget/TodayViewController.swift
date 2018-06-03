//
//  TodayViewController.swift
//  ASE Timer Widget
//
//  Created by Rahul Sharma on 03/09/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.


import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var countdownTimerLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let eventUnixTime: TimeInterval = 1528131600
        let currentUnixTime = Date().timeIntervalSince1970
        
        let secondsUntilEvent: Double = eventUnixTime - currentUnixTime

        if secondsUntilEvent <= 0 {
            self.countdownTimerLabel.text = "Keynote is now streaming live."
            return
        }
        
        let days = Int(secondsUntilEvent / 86400)
        let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
        
        if days != 0 {
            
            if days % 7 == 0 {
                
                let weeks = days / 7
                
                if weeks == 1 {
                    countdownTimerLabel.text = "\(weeks) week"
                }else{
                    countdownTimerLabel.text = "\(weeks) weeks"
                }
                
            }else{
                
                if days == 1 {
                    countdownTimerLabel.text = "\(days) day"
                }else{
                    countdownTimerLabel.text = "\(days) days"
                }
                
            }
            
        }else if hours != 0 {
            
            if hours == 1 {
                countdownTimerLabel.text = "\(hours) hour"
            }else{
                countdownTimerLabel.text = "\(hours) hours"
            }
            
        }else if minutes != 0 {
            
            if minutes == 1 {
                countdownTimerLabel.text = "\(minutes) minute"
            }else{
                countdownTimerLabel.text = "\(minutes) minutes"
            }
            
        }else{
            countdownTimerLabel.text = "Keynote is now streaming live."
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
