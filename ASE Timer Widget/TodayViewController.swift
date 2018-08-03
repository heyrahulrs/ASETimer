//
//  TodayViewController.swift
//  ASE Timer Widget
//
//  Created by Rahul Sharma on 03/09/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.


import UIKit
import NotificationCenter

typealias time = (days: Int, hours: Int, minutes: Int, seconds: Int)

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var countdownTimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkService.shared.downloadEventInfo { (event) in
            
            if let eventUnixTime = event.unixTime {
                self.updateUI(for: eventUnixTime)
            }else{
                self.updateCountdownLabel(with: "Date not known yet")
            }
            
        }
        
    }
    
    fileprivate func updateUI(for eventUnixTime: TimeInterval) {
        
        let eventUnixTime: TimeInterval = eventUnixTime
        let currentUnixTime = Date().timeIntervalSince1970
        
        let secondsUntilEvent: Double = eventUnixTime - currentUnixTime
        
        if secondsUntilEvent <= -7200 {
            updateCountdownLabel(with: "Event has been concluded.")
            return
        }else if secondsUntilEvent <= 0 {
            updateCountdownLabel(with: "Keynote is now streaming live.")
            return
        }
        
        let (days, hours, minutes, _) = getDaysHoursMinutesSeconds(from: secondsUntilEvent)
        
        var text = ""
        
        if days != 0 {
            
            if days % 7 == 0 {
                let weeks = days / 7
                 text = weeks == 1 ? "\(weeks) week" : "\(weeks) weeks"
            }else{
                text = days == 1 ? "\(days) day" : "\(days) days"
            }
            
        }else if hours != 0 {
            text = hours == 1 ? "\(hours) hour" : "\(hours) hours"
        }else if minutes != 0 {
            text = minutes == 1 ? "\(minutes) minute" : "\(minutes) minutes"
        }
        
        countdownTimerLabel.text = text
        
    }
    
    fileprivate func updateCountdownLabel(with text: String) {
        countdownTimerLabel.text = text.uppercased()
        countdownTimerLabel.font = UIFont.systemFont(ofSize: 20)
        countdownTimerLabel.alpha = 0.8
    }
    
    fileprivate func getDaysHoursMinutesSeconds(from secondsUntilEvent: Double) -> time {
        let days = Int(secondsUntilEvent / 86400)
        let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 60))
        return (days, hours, minutes, seconds)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
