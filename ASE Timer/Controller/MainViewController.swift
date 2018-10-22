//
//  MainViewController.swift
//  ASE Timer
//
//  Created by Rahul Sharma on 03/09/17.
//  Copyright © 2017 Rahul Sharma. All rights reserved.
//

import UIKit
import SafariServices

typealias time = (days: Int, hours: Int, minutes: Int, seconds: Int)

class MainViewController: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var eventHeadingLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eventHeadingLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDateAndTimeLabel: UILabel!
    @IBOutlet weak var countdownTimerLabel: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var logoImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageViewTopConstraint: NSLayoutConstraint!

    //MARK: - VARIABLES
    
    var event: ASE!
    var timer: Timer!
    var time: time = (0, 0, 0, 0)
    
    var randomNumber = 0
    
    //MARK: - UI KIT METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.deviceName == .iPhone4S {
            resetUI()
            showAlert(title: "Error", message: "This app doesn't support iPhone 4S.")
            return
        }
        
        let action = #selector(didLongPress)
        let longPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressGestureRecognizer.addTarget(self, action: action)
        view.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let date = Date()
        
        if UIDevice.deviceName == .iPhone4S {
            resetUI()
            showAlert(title: "Error", message: "This app doesn't support iPhone 4S.")
            return
        }
        
        if UIDevice.deviceName == .iPhoneSE {
            eventHeadingLabelTopConstraint.constant = 200
            logoImageViewHeightConstraint.constant = 150
        }
        
        if UIDevice.deviceName == .iPhoneX {
            logoImageViewTopConstraint.constant = 74
        }
        
        if UIDevice.deviceName == .iPad {
            logoImageViewTopConstraint.constant = 90
            logoImageViewHeightConstraint.constant = 302
        }
        
        if event != nil {
            print("Info: Event data is already loaded.")
            return
        }
        
        resetUI()
        
        setRandomAppleLogo()
        
        let isNetworkAvailable = Reachability.isConnectedToNetwork()

        if let eventInfo = getObject(forKey: USER_DEFAULTS_KEY) as? [String: Any] {
            
            print("Info: Event Info is already saved on the device.")

            event = ASE(json: eventInfo)

            if event.checkForUpdatesAfterUnixTime < date.timeIntervalSince1970 {

                if isNetworkAvailable {

                    print("Info: Updating Event Info.")

                    NetworkService.shared.downloadEventInfo { (event) in

                        self.remove(forKey: USER_DEFAULTS_KEY)

                        let data = event.eventInfo()
                        self.save(value: data, forKey: USER_DEFAULTS_KEY)

                        self.event = nil
                        self.event = event
                        self.setupTimer()
                        self.setBackgroundImage()

                    }

                    print("Info: Updated Event Info.")

                }else{
                    print("Error: Device is not connected to network.")
                    showAlert(title: "Error", message: UPDATE_REQUIRED_NETWORK_NOT_AVAILABLE)
                }

            }else{
                print("Info: Updating app UI.")
                setupTimer()
                setBackgroundImage()
            }

        }else{

            print("Info: Downloading Event Info.")

            if isNetworkAvailable {

                NetworkService.shared.downloadEventInfo { (event) in

                    let data = event.eventInfo()
                    self.save(value: data, forKey: USER_DEFAULTS_KEY)

                    self.event = nil
                    self.event = event
                    self.setupTimer()
                    self.setBackgroundImage()

                }

                print("Info: Downloaded Event Info.")

            }else{
                print("Error: Device is not connected to network.")
                showAlert(title: "Error", message: FIRST_LAUNCH_NETWORK_NOT_AVAILABLE)
            }

        }
        
        
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        print("Info: Refreshing details")
        
        UIDevice.vibrate()
        
        setRandomAppleLogo()
        
        resetUI()
        
        NetworkService.shared.downloadEventInfo { (event) in
            
            self.remove(forKey: USER_DEFAULTS_KEY)
            
            let data = event.eventInfo()
            self.save(value: data, forKey: USER_DEFAULTS_KEY)
            
            self.event = event
            self.setupTimer()
            self.setBackgroundImage()
            
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - FILEPRIVATE FUNCTIONS
    
    fileprivate func resetUI() {
        eventHeadingLabel.text = " "
        eventDescriptionLabel.text = "\n\n\n"
        eventDateAndTimeLabel.text = " "
        countdownTimerLabel.text = "-"
        backgroundImageView.image = nil
    }
    
    fileprivate func setRandomAppleLogo() {
        var newRandomNumber = Int.random(in: 1...10)
        while newRandomNumber == randomNumber {
            newRandomNumber = Int.random(in: 1...10)
        }
        randomNumber = newRandomNumber
        let imageName = "hero_logo_\(randomNumber)"
        logoImageView.image = UIImage(named: imageName)
    }
    
    
    fileprivate func setBackgroundImage() {
        
        if logoImageView.image != nil {
            print("Info: Logo Image already set. Returning.")
            return
        }
        
        let eventTitle = event.title.replacingOccurrences(of:" ", with: "")
        let imageName = "\(eventTitle)-\(UIDevice.deviceName.rawValue)"
        
        print("Info: Finding Background Image named: \(imageName)")
        
        if let backgroundImage = UIImage(named: imageName) {
            print("Info: Background Image named: \(imageName) found in app bundle.")
            backgroundImageView.image = backgroundImage
            return
        }
        
        print("Info: Background Image named: \(imageName) not found in app bundle.")
        
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
            print("Info: Date of event not found.")
            shareButton.isHidden = true
            infoButton.isHidden = true
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
            print("Info: Event already concluded. Resetting UI.")
            resetUI()
            eventHeadingLabel.text = eventNamePrediction
            timer.invalidate()
            return
        }else if secondsUntilEvent <= 0 { //Keynote is now streaming live.
            print("Info: Keynote is now streaming live.")
            self.countdownTimerLabel.text = KEYNOTE_IS_LIVE
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
    
    fileprivate func presentActivityViewController() {
        
        guard let event = event, let _ = event.unixTime else { return }
        
        shareButton.isHidden = true
        infoButton.isHidden = true
        
        let (days, hours, minutes, _) = time
        
        var text = ""
        
        if days != 0 {
            
            if days % 7 == 0 {
                let weeks = days / 7
                text = weeks == 1 ? "\(weeks) week" : "\(weeks) weeks"
            }else{
                text = days == 1 ? "\(days) day" : "\(days) days"
            }
            
        }else if hours != 0 {
            
            text = hours == 1 ? "\(hours) hour" : "\(hours) hours"
            
        }else if minutes % 5 == 0 {
            
            text = "\(minutes) minutes"
            
        }
        
        countdownTimerLabel.text = text
        
        let screenshot = takeScreenshot(of: view)
        
        shareButton.isHidden = false
        infoButton.isHidden = false
        
        if text == "" {
            return
        }
        
        let caption = "\(text) until \(event.title)."
        
        let viewController = UIActivityViewController(activityItems: [screenshot, caption], applicationActivities: nil)
        present(viewController, animated: true)
        
        //FIX TO CRASH WHILE PRESENTING ACTIVITY VIEW CONTROLLER ON iPads
        if let popOver = viewController.popoverPresentationController {
            popOver.sourceView = view
            popOver.sourceRect = logoImageView.frame
        }
        
    }
    
    //MARK: - ACTIONS
    
    @IBAction func didTapShareButton() {
        presentActivityViewController()
    }
    
    @IBAction func didTapInfoButton() {
        
        let url = URL(staticString: "https://www.apple.com/apple-events/")
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        
        present(safariViewController, animated: true)
        
    }
    
    //MARK: - SELECTORS
    
    @objc func didLongPress() {
        presentActivityViewController()
    }
    
    //MARK: - FUNCTIONS
    
    func getObject(forKey key: String) -> Any? {
        
        print("Info: Getting Data for key: \(key) from the device.")

        let defaults = UserDefaults.standard
        
        if let object = defaults.object(forKey: key) {
            return object
        }
        
        return nil
        
    }
    
    func save(value: [String: Any], forKey key: String) {
        
        print("Info: Saving Data for key: \(key) to the device.")
        
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: key)
        
    }
    
    func remove(forKey key: String) {
        
        print("Info: Removing Data for key: \(key) from the device.")

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        
    }
    
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
        case 11, 12, 1...3:
            return "Apple March Event"
            
        case 4...5:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY"
            let year = dateFormatter.string(from: date)
            return "WWDC \(year)"
            
        case 6...8:
            return "Apple September Event"
            
        case 9...10:
            return "Apple October Event"
            
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

extension MainViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
    
}

