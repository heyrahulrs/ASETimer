//
//  InterfaceController.swift
//  ASE Timer WatchKit App Extension
//
//  Created by Rahul Sharma on 5/16/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    var event: ASE?
    
    @IBOutlet weak var eventTitleLabel: WKInterfaceLabel!
    @IBOutlet weak var timeRemainingLabel: WKInterfaceLabel!

    @IBOutlet weak var timeLeftTimer: WKInterfaceTimer!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        updateUI()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        event = nil
    }

    func updateUI() {
        
        event = EventManager.getEventInfo()
        
        guard let event = event else { return }
        
        eventTitleLabel.setText(event.title)
        
        guard let eventUnixTime = event.unixTime else { return }
        
        let eventDate = Date(timeIntervalSince1970: eventUnixTime)
        timeLeftTimer.setDate(eventDate)
        
    }
}
