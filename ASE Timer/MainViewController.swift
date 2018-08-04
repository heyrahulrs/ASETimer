//
//  MainViewController.swift
//  ASE Timer
//
//  Created by Rahul Sharma on 03/09/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.
//

import UIKit

typealias time = (days: Int, hours: Int, minutes: Int, seconds: Int)

class MainViewController: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var eventHeadingLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDateAndTimeLabel: UILabel!
    @IBOutlet weak var countdownTimerLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //MARK: - VARIABLES
    
    var event: ASE!
    var timer: Timer!
    var time: time = (0, 0, 0, 0)
    
    //MARK: - UI KIT METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetUI()
        
        NetworkService.shared.downloadEventInfo { (event) in
            self.event = event
            self.setupTimer()
            self.setBackgroundImage()
        }
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        view.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        print("Refreshing details")
        
        resetUI()
        
        NetworkService.shared.downloadEventInfo { (event) in
            self.event = event
            self.setupTimer()
            self.setBackgroundImage()
        }
        
    }
    
    //MARK: - FILEPRIVATE FUNCTIONS
    
    fileprivate func resetUI() {
        eventHeadingLabel.text = " "
        eventDescriptionLabel.text = "\n\n\n"
        eventDateAndTimeLabel.text = " "
        countdownTimerLabel.text = "-"
        backgroundImageView.image = nil
    }
    
    fileprivate func setBackgroundImage() {
        
        let eventTitle = event.title.replacingOccurrences(of:" ", with: "")
        let imageName = "\(eventTitle)-\(UIDevice.deviceName.rawValue)"
        
        print(imageName)
        
        if let backgroundImage = UIImage(named: imageName) {
            backgroundImageView.image = backgroundImage
        }else{
            event.downloadBackgroundImage {
                self.backgroundImageView.image = self.event.backgroundImage
            }
        }
        
    }
    
    fileprivate func setupTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateLabels()
        }
        
    }
    
    fileprivate func updateLabels() {
        
        eventHeadingLabel.text = event.title
        eventDescriptionLabel.text = event.description
        
        guard let eventUnixTime = event.unixTime else {
            timer.invalidate()
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        let date = Date(timeIntervalSince1970: eventUnixTime)
        
        eventDateAndTimeLabel.text = dateFormatter.string(from: date).uppercased()
        
        let currentUnixTime = Date().timeIntervalSince1970
        
        let secondsUntilEvent: Double = eventUnixTime - currentUnixTime
        
        if secondsUntilEvent <= -7200 { //Event already concluded
            resetUI()
            eventHeadingLabel.text = eventNamePrediction
            timer.invalidate()
            return
        }else if secondsUntilEvent <= 0 { //Keynote is now streaming live.
            self.countdownTimerLabel.text = "Keynote is now streaming live."
            timer.invalidate()
            return
        }
        
        time = getDaysHoursMinutesSeconds(from: secondsUntilEvent)
        
        updateCountdownLabel(for: time)
        
    }
    
    fileprivate func updateCountdownLabel(for time: time) {
        
        let (days, hours, minutes, seconds) = time
        
        if days != 0 {
            countdownTimerLabel.text = "\(days)d \(hours)h \(minutes)m \(seconds)s"
        }else if days == 0 {
            countdownTimerLabel.text = "\(hours)h \(minutes)m \(seconds)s"
        }else if hours == 0 {
            countdownTimerLabel.text = "\(minutes)m \(seconds)s"
        }else if minutes == 0 {
            countdownTimerLabel.text = "\(seconds)s"
        }
        
    }
    
    //MARK: - ACTIONS
    
    //MARK: - SELECTORS
    
    @objc func didLongPress() {
        
        var image: UIImage?
        
        let (days, hours, minutes, _) = time
        
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
            
            image = takeScreenshot(of: view)
            
        }else if hours != 0 {
            
            if hours == 1 {
                countdownTimerLabel.text = "\(hours) hour"
            }else{
                countdownTimerLabel.text = "\(hours) hours"
            }
            
            image = takeScreenshot(of: view)
            
        }else if minutes % 5 == 0 {
            
            countdownTimerLabel.text = "\(minutes) minutes"
            image = takeScreenshot(of: view)
            
        }
        
        guard let screenshot = image else { return }
        
        let viewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        self.present(viewController, animated: true)
        
    }
    
    //MARK: - FUNCTIONS
    
    func takeScreenshot(of view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }

    var eventNamePrediction: String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        
        let month = Int(dateFormatter.string(from: date))!
        
        switch month {
        case 9...12, 1...3:
            return "Apple March Event"
            
        case 4...5:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY"
            let year = dateFormatter.string(from: date)
            return "WWDC \(year)"
            
        case 6...8:
            return "Apple September Event"
            
        default:
            return "Next Apple Event"
        }
    }
    
    func getDaysHoursMinutesSeconds(from secondsUntilEvent: Double) -> time {
        let days = Int(secondsUntilEvent / 86400)
        let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 60))
        return (days, hours, minutes, seconds)
    }
    
}

