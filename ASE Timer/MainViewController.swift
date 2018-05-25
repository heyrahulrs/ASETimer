//
//  MainViewController.swift
//  ASE Timer
//
//  Created by Rahul Sharma on 03/09/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var countdownTimerLabel: UILabel!
    
    var days = 0
    var hours = 0
    var minutes = 0
    var seconds = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let eventUnixTime: TimeInterval = 1528131600
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            let currentUnixTime = Date().timeIntervalSince1970
            
            let secondsUntilEvent: Double = eventUnixTime - currentUnixTime
            
            if secondsUntilEvent <= 0 {
                self.countdownTimerLabel.text = "Keynote is now streaming live."
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
            
            self.countdownTimerLabel.text = "\(days)d \(hours)h \(minutes)m \(seconds)s"
        }
        
    }
    
    @IBAction func didLongPress(_ sender: UILongPressGestureRecognizer) {
        
        var image: UIImage?
        
        if days != 0 {
            countdownTimerLabel.text = "\(days) days"
            image = takeScreenshot(of: view)
            countdownTimerLabel.text = "\(days)d \(hours)h \(minutes)m \(seconds)s"
        }else if hours != 0 {
            countdownTimerLabel.text = "\(hours) hours"
            image = takeScreenshot(of: view)
            countdownTimerLabel.text = "\(days)d \(hours)h \(minutes)m \(seconds)s"
        }else if minutes != 0 {
            countdownTimerLabel.text = "\(minutes) minutes"
            image = takeScreenshot(of: view)
            countdownTimerLabel.text = "\(days)d \(hours)h \(minutes)m \(seconds)s"
        }
        
        let viewController = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        self.present(viewController, animated: true)
        
    }
    
    func takeScreenshot(of view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }

}

