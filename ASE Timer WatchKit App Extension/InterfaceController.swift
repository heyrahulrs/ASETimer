//
//  InterfaceController.swift
//  ASE Timer WatchKit App Extension
//
//  Created by Rahul Sharma on 5/16/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import WatchKit

class InterfaceController: WKInterfaceController {
    
    var event: ASE?
    
    @IBOutlet weak var eventTitleLabel: WKInterfaceLabel!

    @IBOutlet weak var timeLeftTimer: WKInterfaceTimer!
    @IBOutlet weak var infoLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        infoLabel.setText("")
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
        
        if eventUnixTime + 7200.0 < Date().timeIntervalSince1970  {
            infoLabel.setText("Event has been councluded.")
            timeLeftTimer.setHidden(true)
            return
        } else if eventUnixTime < Date().timeIntervalSince1970  {
            infoLabel.setText("Event is now streaming.")
            timeLeftTimer.setHidden(true)
            return
        }
        
        let eventDate = Date(timeIntervalSince1970: eventUnixTime)
        timeLeftTimer.setDate(eventDate)
        
        infoLabel.setHidden(true)

    }
    
}
