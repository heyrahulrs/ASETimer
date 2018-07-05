//
//  MainViewController.swift
//  ASE Timer
//
//  Created by Rahul Sharma on 03/09/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.
//

import UIKit

var databaseURL: URL? {
    let url = URL(string: "https://asetimer.firebaseio.com/.json")
    return url
}

var key: String {
    return "event-json"
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var eventHeadingLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var countdownTimerLabel: UILabel!
    @IBOutlet weak var eventDateAndTimeLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var days = 0
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    var event: ASE!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        eventHeadingLabel.text = " "
        eventDescriptionLabel.text = "\n\n\n"
        eventDateAndTimeLabel.text = " "
        countdownTimerLabel.text = " - "
        
        let defaults = UserDefaults.standard
        
        if let json = defaults.dictionary(forKey: key) {
            
            print("Event Info already saved in device.")
            self.event = ASE(json: json)
            
            guard let eventUnixTime: Double = event.unixTime else {
                defaults.removeObject(forKey: key)
                getInfo()
                return
            }

            let currentUnixTime: Double = Date().timeIntervalSince1970
            
            if currentUnixTime > eventUnixTime + 7200 {
                print("Event Over")
                defaults.removeObject(forKey: key)
                getInfo()
                return
            }
            
            setupTimer()
            
        }else{
            print("No Event Info saved in device. Downloading data from server.")
            getInfo()
        }
        
    }
    
    func getInfo() {
        
        guard let databaseURL = databaseURL else {
            print("Error: cannot create URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: databaseURL) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Data not convertable to JSON")
                    return
                }
                
                self.event = ASE(json: json)
                
                //SAVE TO DEVICE
                let defaults = UserDefaults.standard
                defaults.set(json, forKey: key)
                
                DispatchQueue.main.sync {
                    self.setupTimer()
                }
            

            } catch{
                print("error trying to convert data to JSON")
                return
            }
            
        }
        
        task.resume()
        
    }
    
    func setupTimer() {
                
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateLabels(at: timer)
        }
        
    }
    
    func updateLabels(at timer: Timer) {
        
        activityIndicator.stopAnimating()
        
        eventHeadingLabel.text = event.title
        eventDescriptionLabel.text = event.description ?? ""
        
        guard let eventUnixTime = event.unixTime else {
            print("No Event Available at this time")
            self.eventDateAndTimeLabel.text = "Date not known yet".uppercased()
            self.backgroundImageView.image = nil
            removeObjectFromDevice()
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
        
        if secondsUntilEvent <= -7200 {
            print("Event already concluded")
            print("Resetting Data")
            self.eventHeadingLabel.text = self.eventNamePrediction()
            self.eventDescriptionLabel.text = ""
            self.countdownTimerLabel.text = " - "
            self.eventDateAndTimeLabel.text = "Date not known yet".uppercased()
            self.backgroundImageView.image = nil
            removeObjectFromDevice()
            timer.invalidate()
            return
        }
        
        if secondsUntilEvent <= 0 {
            self.countdownTimerLabel.text = "Keynote is now streaming live."
            removeObjectFromDevice()
            timer.invalidate()
            return
        }
        
        let days = Int(secondsUntilEvent / 86400)
        let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 60))
        
        self.days = days
        self.minutes = minutes
        self.hours = hours
        self.seconds = seconds
        
        
        if days != 0 {
            countdownTimerLabel.text = "\(days)d \(hours)h \(minutes)m \(seconds)s"
        }
        
        if days == 0 {
            countdownTimerLabel.text = "\(hours)h \(minutes)m \(seconds)s"
        }else if hours == 0 {
            countdownTimerLabel.text = "\(minutes)m \(seconds)s"
        }else if minutes == 0 {
            countdownTimerLabel.text = "\(seconds)s"
        }
        
    }
    
    @IBAction func didLongPress(_ sender: UILongPressGestureRecognizer) {
        
        var image: UIImage?
        
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
    
    func takeScreenshot(of view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }

    func eventNamePrediction() -> String {
        
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
    
    func removeObjectFromDevice() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
    
}

