//
//  MainViewController.swift
//  ASE Timer
//
//  Created by Rahul on 3/10/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var eventHeadingLabel: UILabel!

    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var hoursLeftLabel: UILabel!
    @IBOutlet weak var minutesLeftLabel: UILabel!
    @IBOutlet weak var secondsLeftLabel: UILabel!
    
    @IBOutlet var seperatorLabels: [UILabel]!
    
    @IBOutlet weak var countdownStackView: UIStackView!
    
    //MARK:- UI KIT METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetUI()

        let event = EventManager.getEventInfo()
        
        eventHeadingLabel.text = event.title
        
        updateLogoImage()
        
        guard let eventUnixTime = event.unixTime else {
            print("Info: No Date Known.")
            self.updateUI(withFallbackText: DATE_UNKOWN)
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            let currentUnixTime = Date().timeIntervalSince1970
            let secondsLeftUntilEvent = eventUnixTime - currentUnixTime
            
            if secondsLeftUntilEvent <= -7200 {
                self.updateUI(withFallbackText: EVENT_CONCLUDED)
                timer.invalidate()
            }else if secondsLeftUntilEvent <= 0 {
                self.updateUI(withFallbackText: KEYNOTE_IS_LIVE)
                timer.invalidate()
            }
            
            let countdownTime = EventManager.getCountdownTime(from: secondsLeftUntilEvent)
            
            self.updateUI(withCountdownTime: countdownTime)

        }
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIDevice.deviceName == .iPhone4S {
            resetUI()
            showAlert(title: "Sorry", message: "Sorry. This app doesn't support iPhone 4S.")
            return
        }
                
        if UIDevice.deviceName == .iPhoneSE {
            
            daysLeftLabel.font = UIFont(name: "AvenirNext-Bold", size: 38)
            hoursLeftLabel.font = UIFont(name: "AvenirNext-Bold", size: 38)
            minutesLeftLabel.font = UIFont(name: "AvenirNext-Bold", size: 38)
            secondsLeftLabel.font = UIFont(name: "AvenirNext-Bold", size: 38)
            
            seperatorLabels.forEach{
                $0.font = UIFont.systemFont(ofSize: 38, weight: .semibold)
            }
        }
        
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        updateLogoImage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- FUNCTIONS
    
    func updateUI(withCountdownTime countdownTime: Countdown) {
        daysLeftLabel.text = countdownTime.days.stringWithLeadingZeros
        hoursLeftLabel.text = countdownTime.hours.stringWithLeadingZeros
        minutesLeftLabel.text = countdownTime.minutes.stringWithLeadingZeros
        secondsLeftLabel.text = countdownTime.seconds.stringWithLeadingZeros
    }
    
    func updateUI(withFallbackText fallbackText: String) {
        infoLabel.alpha = 1.0; infoLabel.isHidden = false
        infoLabel.text = fallbackText
        countdownStackView.isHidden = true
    }
    
    func updateLogoImage() {
        let event = EventManager.getEventInfo()
        if event.title == "WWDC 2019" {
            let imageName = "WWDC2019-\(Int.random(in: 1...4))"
            logoImageView.image = UIImage(named: imageName)
        }else{
            logoImageView.image = UIImage(named: "March2019")
        }
    }
    
    func resetUI() {
        daysLeftLabel.text = "00"
        hoursLeftLabel.text = "00"
        minutesLeftLabel.text = "00"
        secondsLeftLabel.text = "00"
    }

}
