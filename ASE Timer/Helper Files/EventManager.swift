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
    
    static func getEventInfo() -> ASE {
//        return ASE(title: "WWDC 2019",
//                   description: "Apple Special Event June 2019",
//                   unixTime: 1559581200)
        return ASE(title: "Apple Special Event",
                   description: "Live from the Steve Jobs Theater in Cupertino. March 25, 2019, at 10:00 a.m.",
                   unixTime: 1553533200)
    }
    
    static func getCountdownTime(from secondsUntilEvent: Double) -> Countdown {
        let days = Int(secondsUntilEvent / 86400)
        let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 60))
        return (days, hours, minutes, seconds)
    }
    
    static func getTextForWidget(from secondsUntilEvent: Double) -> String {
        
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
