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
        
        let event = EventManager.getEventInfo()
        updateUI(for: event)
        
    }
    
    fileprivate func updateUI(for event: ASE) {
                
        guard let eventUnixTime: TimeInterval = event.unixTime else {
            updateCountdownLabel(withFallbackText: DATE_UNKOWN)
            return
        }
        
        let currentUnixTime = Date().timeIntervalSince1970
        
        let secondsUntilEvent: Double = eventUnixTime - currentUnixTime
        
        if secondsUntilEvent <= -7200 {
            updateCountdownLabel(withFallbackText: EVENT_CONCLUDED)
            return
        }else if secondsUntilEvent <= 0 {
            updateCountdownLabel(withFallbackText: KEYNOTE_IS_LIVE)
            return
        }
        
        let text = EventManager.getTextForWidget(from: secondsUntilEvent)
        
        if text == "" {
            updateCountdownLabel(withFallbackText: LIVESTREAM_WILL_START_ANYTIME_NOW)
            return
        }
        
        countdownTimerLabel.text = text.uppercased()
        
    }
    
    fileprivate func updateCountdownLabel(withFallbackText text: String) {
        countdownTimerLabel.text = text.uppercased()
        countdownTimerLabel.font = UIFont.systemFont(ofSize: 18)
        countdownTimerLabel.alpha = 0.7
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
