//
//  EventManager.swift
//  ASE Timer
//
//  Created by Rahul on 7/23/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import UIKit

public typealias Countdown = (days: Int, hours: Int, minutes: Int, seconds: Int)

class EventManager {
    
    static var shared = EventManager()
    
    /// Returns Upcoming Apple Special Event Info
    static func getEventInfo() -> ASE {
        return ASE(title: "Apple Special Event",
                   description: "Live from Steve Jobs Theatre.",
                   unixTime: nil)
    }
    
    static func getCountdownTime(from secondsUntilEvent: Double) -> Countdown {
        let days = Int(secondsUntilEvent / 86400)
        let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 60))
        return (days, hours, minutes, seconds)
    }
    
    static func getReadableText(from secondsUntilEvent: Double) -> String {
        
        let (days, hours, minutes, _) = getCountdownTime(from: secondsUntilEvent)
        
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
        
        return text
        
    }
    
}
