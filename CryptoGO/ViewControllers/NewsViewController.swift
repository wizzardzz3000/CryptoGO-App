//
//  NewsViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 22/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import Answers

class NewsViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var cryptoGOView: UIView!
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    override func viewDidLoad() {
        
        if let position = UserDefaults.standard.string(forKey: "segmentedPosition") {
            if position == "user" {
                cryptoGOView.isHidden = true
                userView.isHidden = false
                segmentedControl.selectedSegmentIndex = 2
            } else {
                cryptoGOView.isHidden = false
                userView.isHidden = true
                segmentedControl.selectedSegmentIndex = 0
            }
        } else {
            cryptoGOView.isHidden = false
            userView.isHidden = true
        }
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Info Page", style: UIAlertActionStyle.default, handler: { (action) in
            let infoViewController = self.storyboard?.instantiateViewController(withIdentifier: "infoViewController")
            self.present(infoViewController!, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlTapped(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            cryptoGOView.isHidden = false
            userView.isHidden = true
            UserDefaults.standard.set("cryptoGO", forKey: "segmentedPosition")
        case 1:
            alert(title: "Coming Soon 🙃", message: "In the meantime, add your own favorite news sources in the User section.")
        case 2:
            cryptoGOView.isHidden = true
            userView.isHidden = false
            UserDefaults.standard.set("user", forKey: "segmentedPosition")
        default:
            break
        }
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
