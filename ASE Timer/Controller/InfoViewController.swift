//
//  InfoViewController.swift
//  ASE Timer
//
//  Created by Rahul on 3/11/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit
import SafariServices

protocol EventSharingDelegate {
    func didTapShareCountdownTimeButton(atUnixTime unixTime: TimeInterval)
}

class InfoViewController: UITableViewController {
    
    var delegate: EventSharingDelegate?

    //MARK: - UI KIT METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let event = EventManager.getEventInfo()
        
        title = event.title
        
    }
    
    //MARK: - IB ACTIONS
    
    @IBAction func didTapWatchKeynoteButton() {
        
        let url = URL(string: "https://www.apple.com/apple-events/livestream")!
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        
        present(safariViewController, animated: true)
        
    }
    
    @IBAction func didTapShareCountdownButton() {
        self.dismiss(animated: true)
        delegate?.didTapShareCountdownTimeButton(atUnixTime: Date().timeIntervalSince1970)
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
