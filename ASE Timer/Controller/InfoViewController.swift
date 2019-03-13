//
//  InfoViewController.swift
//  ASE Timer
//
//  Created by Rahul on 3/11/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit
import SafariServices

class InfoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let event = EventManager.getEventInfo()
        
        title = event.title
        
    }
    
    @IBAction func didTapEventLinkButton() {
        
        let url = URL(staticString: "https://www.apple.com/apple-events/")
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        
        present(safariViewController, animated: true)
        
    }
    
    @IBAction func didTapShareCountdownButton() {
        
        let event = EventManager.getEventInfo()
        let currentUnixTime = Date().timeIntervalSince1970
        
        let secondsUntilEvent =  event.unixTime! - currentUnixTime
        
        let timeLeft = EventManager.getTextForWidget(from: secondsUntilEvent)

        let text = "\(timeLeft) until \(event.title). #AppleEvent"

        print(text)
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: [])
        present(activityViewController, animated: true)
        
    }
    
    @IBAction func didTapDoneButton() {
        self.dismiss(animated: true)
    }

}


extension InfoViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
    
}
