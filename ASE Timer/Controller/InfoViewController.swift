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

    //MARK: - UI KIT METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        let event = EventManager.getEventInfo()
        
        title = event.title
        
    }
    
    //MARK: - IB ACTIONS
    @IBAction func didTapEventLinkButton(_ sender: UIButton) {
        
        guard let title = sender.title(for: .normal) else { return }
        
        let url = URL(string: title)!
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        
        present(safariViewController, animated: true)
        
    }
    
    @IBAction func didTapShareCountdownButton() {
        
        let event = EventManager.getEventInfo()
        let currentUnixTime = Date().timeIntervalSince1970
        
        guard let eventUnixTime = event.unixTime else { return }
        
        let secondsUntilEvent =  eventUnixTime - currentUnixTime
        
        let timeLeft = EventManager.getReadableText(from: secondsUntilEvent)

        let text = "\(timeLeft) until \(event.title). #AppleEvent"

        print(text)
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: [])
        present(activityViewController, animated: true)
        
    }
    
    @IBAction func didTapDoneButton() {
        self.dismiss(animated: true)
    }

}


//MARK: - SFSafariViewControllerDelegate
extension InfoViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
    
}
