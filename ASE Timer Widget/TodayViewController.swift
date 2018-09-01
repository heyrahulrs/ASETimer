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
    
    @IBOutlet weak var eventHeadingLabel: UILabel!
    @IBOutlet weak var countdownTimerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkService.shared.downloadEventInfo { event in
            
            if let _ = event.unixTime {
                self.updateUI(for: event)
            }else{
                self.updateCountdownLabel(withFallbackText: DATE_UNKOWN)
            }
            
        }
        
    }
    
    fileprivate func updateUI(for event: ASE) {
        
        eventHeadingLabel.text = event.title
        
        guard let eventUnixTime: TimeInterval = event.unixTime else { return }
        
        let currentUnixTime = Date().timeIntervalSince1970
        
        let secondsUntilEvent: Double = eventUnixTime - currentUnixTime
        
        if secondsUntilEvent <= -7200 {
            updateCountdownLabel(withFallbackText: EVENT_CONCLUDED)
            return
        }else if secondsUntilEvent <= 0 {
            updateCountdownLabel(withFallbackText: KEYNOTE_IS_LIVE)
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
    
    fileprivate func updateCountdownLabel(withFallbackText text: String) {
        
        eventHeadingLabel.isHidden = true
        
        countdownTimerLabel.text = text.uppercased()
        countdownTimerLabel.font = UIFont.systemFont(ofSize: 20)
        countdownTimerLabel.alpha = 0.7
        
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
