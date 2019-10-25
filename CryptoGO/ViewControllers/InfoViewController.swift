//
//  InfoViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 23/01/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import UserNotifications
import Crashlytics
import Answers

class InfoViewController : UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var applicationVersionLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.applicationVersionLabel.text = "CryptoGo Version \(version)"
        }
    }
    
    //Links functions
    //----------------
    @IBAction func linkButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://www.cryptogo.tech/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    //Email functions
    //----------------
    func sendFeedback() {
        if !MFMailComposeViewController.canSendMail() {
            print("Can not send mail")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["contact@cryptogo.tech"])
        mailComposer.setSubject("Feedback")
        present(mailComposer, animated: true, completion: nil)
    
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        segmentedControl.selectedSegmentIndex = -1
        
        switch result {
        case .cancelled:
            print("Sending Mail is cancelled")
            Answers.logCustomEvent(withName: "User Cancelled Email", customAttributes: nil)
        case .failed :
            print("Message sending failed")
            Answers.logCustomEvent(withName: "Email failed to be sent", customAttributes: nil)
            mailErrorAlert()
        case .sent :
            print("Your Mail has been sent successfully")
            Answers.logCustomEvent(withName: "User Successfully sent email", customAttributes: nil)
            mailSuccessAlert()
        case .saved :
            print("Sending Mail is Saved")
            Answers.logCustomEvent(withName: "User Saved Email", customAttributes: nil)
        }
    }
    
    func mailSentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func mailErrorAlert() {
        mailSentAlert(title: "Could Not Send Email 😢", message: "Your device could not send the mail. Please check your configuration and try again.")
    }
    func mailSuccessAlert() {
        mailSentAlert(title: "Email Sent 😊", message: "Thank you for your feedback. If you had questions, we will get back to you soon.")
    }
    
    //Segmented control
    //------------------
    @IBAction func infoSegmentedControlTapped(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.dismiss(animated: true, completion: nil)
        case 1:
            sendFeedback()
            Answers.logCustomEvent(withName: "User Clicked Feedback Button", customAttributes: nil)
        default:
            break
        }
    }
}

