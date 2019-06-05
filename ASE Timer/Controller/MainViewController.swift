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
    
    @IBOutlet weak var daysHoursSeparator: UILabel!
    @IBOutlet weak var hoursMinutesSeparator: UILabel!
    @IBOutlet weak var minutesSecondsSeparator: UILabel!
    
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    @IBOutlet var seperatorLabels: [UILabel]!
    
    @IBOutlet weak var countdownStackView: UIStackView!
    
    @IBOutlet weak var infoButton: UIButton!
    
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
            }else if secondsLeftUntilEvent < 0 {
                self.updateUI(withFallbackText: KEYNOTE_IS_LIVE)
                timer.invalidate()
            }
            
            let countdownTime = EventManager.getCountdownTime(from: secondsLeftUntilEvent)
            self.updateUI(withCountdownTime: countdownTime)

        }
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
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
    
    //MARK:- IB ACTIONS
    
    @IBAction func didTapInfoButton() {
        
        let identifier = "UINavigationController"

        let nextViewController = storyboard?.instantiateViewController(withIdentifier: identifier) as! UINavigationController        
        
        nextViewController.modalPresentationStyle = .popover
        
        let infoViewController = nextViewController.viewControllers.first as! InfoViewController
        infoViewController.delegate = self
        
        self.present(nextViewController, animated: true)
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
    
    func revertFromFallbackUI() {
        
        infoLabel.alpha = 0.0; infoLabel.isHidden = true
        infoLabel.text = ""
        countdownStackView.isHidden = false
        
        daysLeftLabel.isHidden = false
        hoursLeftLabel.isHidden = false
        minutesLeftLabel.isHidden = false
        secondsLeftLabel.isHidden = false
        
        daysHoursSeparator.isHidden = false
        hoursMinutesSeparator.isHidden = false
        minutesSecondsSeparator.isHidden = false
        
        daysLabel.isHidden = false
        hoursLabel.isHidden = false
        minutesLabel.isHidden = false
        secondsLabel.isHidden = false
        
        daysLabel.text = "Days".uppercased()
        hoursLabel.text = "Hours".uppercased()
        minutesLabel.text = "Minutes".uppercased()
        secondsLabel.text = "Seconds".uppercased()
        
        infoButton.isHidden = false
        
    }
    
    func updateLogoImage() {
        let imageName = ""
        logoImageView.image = UIImage(named: imageName)
    }
    
    func resetUI() {
        daysLeftLabel.text = "00"
        hoursLeftLabel.text = "00"
        minutesLeftLabel.text = "00"
        secondsLeftLabel.text = "00"
    }

}

//MARK: - MyDelegate

extension MainViewController: MyDelegate {
    
    func didTapShareCountdownTimeButton(atUnixTime unixTime: TimeInterval) {
        
        let event = EventManager.getEventInfo()
        
        guard let eventUnixTime = event.unixTime else { return }
        
        let secondsUntilEvent =  eventUnixTime - unixTime
        
        let countdownTimeLeft = EventManager.getCountdownTime(from: secondsUntilEvent)
        
        var text = ""
        
        daysHoursSeparator.isHidden = true
        hoursMinutesSeparator.isHidden = true
        minutesSecondsSeparator.isHidden = true
        
        infoButton.isHidden = true
        
        if countdownTimeLeft.days != 0 {
            
            if countdownTimeLeft.days == 1 {
                text = "\(countdownTimeLeft.days) day until \(event.hashtag)."
                daysLabel.text = "DAY"
            }else{
                text = "\(countdownTimeLeft.days) days until \(event.hashtag)."
            }
            
            hoursLeftLabel.isHidden = true
            minutesLeftLabel.isHidden = true
            secondsLeftLabel.isHidden = true
            
            hoursLabel.isHidden = true
            minutesLabel.isHidden = true
            secondsLabel.isHidden = true
            
        } else if countdownTimeLeft.hours != 0 {
            
            if countdownTimeLeft.days == 1 {
                text = "\(countdownTimeLeft.hours) hour until \(event.hashtag)."
                hoursLabel.text = "HOUR"
            }else{
                text = "\(countdownTimeLeft.hours) hours until \(event.hashtag)."
            }
            
            daysLeftLabel.isHidden = true
            minutesLeftLabel.isHidden = true
            secondsLeftLabel.isHidden = true
            
            daysLabel.isHidden = true
            minutesLabel.isHidden = true
            secondsLabel.isHidden = true
            
        } else if countdownTimeLeft.minutes != 0 {
            
            if countdownTimeLeft.minutes == 1 {
                text = "\(countdownTimeLeft.minutes) minute until \(event.hashtag)."
                minutesLabel.text = "MINUTE"
            }else{
                text = "\(countdownTimeLeft.minutes) minutes until \(event.hashtag)."
            }
            
            daysLeftLabel.isHidden = true
            hoursLeftLabel.isHidden = true
            secondsLeftLabel.isHidden = true
            
            daysLabel.isHidden = true
            hoursLabel.isHidden = true
            secondsLabel.isHidden = true
            
        } else if countdownTimeLeft.seconds != 0 {
            
            text = "\(countdownTimeLeft.seconds) seconds until \(event.hashtag)."
            
            daysLeftLabel.isHidden = true
            hoursLeftLabel.isHidden = true
            minutesLeftLabel.isHidden = true
            
            daysLabel.isHidden = true
            hoursLabel.isHidden = true
            minutesLabel.isHidden = true
            
        }
        
        let image  = view.takeScreenshot()
        
        revertFromFallbackUI()
        
        let activityViewController = UIActivityViewController(activityItems: [image, text], applicationActivities: [])
        
        present(activityViewController, animated: true)
                
    }
    
}
