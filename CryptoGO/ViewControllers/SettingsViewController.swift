//
//  SettingsViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 22/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import Answers

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var cryptoSelector: UISegmentedControl!
    
    @IBOutlet weak var aggressiveSwitch: UISwitch!
    @IBOutlet weak var aggressiveInfoButton: UIButton!
    
    @IBOutlet weak var infosButton: UIButton!
    
    static var cell1 : Bool = false
    static var cell2 : Bool = false
    static var cell3 : Bool = false
    static var cell4 : Bool = false
    static var cell5 : Bool = false
    
    static var currencyCode : String = ""
    static var currencySymbol : String = ""
    static var currencyLogo = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        if let cell1symbol = UserDefaults.standard.string(forKey: "cell1symbol") {
            cryptoSelector.setTitle(cell1symbol, forSegmentAt: 0)
        } else {
            cryptoSelector.setTitle(SettingsPickerViewController.cell1CryptoSymbol, forSegmentAt: 0)
        }
        if let cell2symbol = UserDefaults.standard.string(forKey: "cell2symbol") {
            cryptoSelector.setTitle(cell2symbol, forSegmentAt: 0)
        } else {
            cryptoSelector.setTitle(SettingsPickerViewController.cell2CryptoSymbol, forSegmentAt: 1)
        }
        if let cell3symbol = UserDefaults.standard.string(forKey: "cell3symbol") {
            cryptoSelector.setTitle(cell3symbol, forSegmentAt: 0)
        } else {
            cryptoSelector.setTitle(SettingsPickerViewController.cell3CryptoSymbol, forSegmentAt: 2)
        }
        if let cell4symbol = UserDefaults.standard.string(forKey: "cell4symbol") {
            cryptoSelector.setTitle(cell4symbol, forSegmentAt: 0)
        } else {
            cryptoSelector.setTitle(SettingsPickerViewController.cell4CryptoSymbol, forSegmentAt: 3)
        }
        if let cell5symbol = UserDefaults.standard.string(forKey: "cell5symbol") {
            cryptoSelector.setTitle(cell5symbol, forSegmentAt: 0)
        } else {
            cryptoSelector.setTitle(SettingsPickerViewController.cell5CryptoSymbol, forSegmentAt: 4)
        }
        */
        
        if SettingsViewController.currencyLogo == "€" { segmentedControl.selectedSegmentIndex = 1 }
        else if SettingsViewController.currencyLogo == "£" { segmentedControl.selectedSegmentIndex = 2 }
        else if SettingsViewController.currencyLogo == "¥" { segmentedControl.selectedSegmentIndex = 3 }
        else if SettingsViewController.currencyLogo == "₽" { segmentedControl.selectedSegmentIndex = 4 }
        else { segmentedControl.selectedSegmentIndex = 0 }
     
        if let aggressiveSwitchState = UserDefaults.standard.object(forKey: "aggressiveSwitchState") as? Bool {
            MainViewController.aggressiveSwitchState = aggressiveSwitchState
            if MainViewController.aggressiveSwitchState == true {
                aggressiveSwitch.isOn = true
            }
        }
    }

    // ---> Aggressive Switch
    //------------------------
    @IBAction func aggressiveTMSwitchTapped(_ sender: UISwitch) {
        if aggressiveSwitch.isOn {
            MainViewController.aggressiveSwitchState = true
            UserDefaults.standard.set(MainViewController.aggressiveSwitchState, forKey: "aggressiveSwitchState")
            Answers.logCustomEvent(withName: "User Enabled Aggressive TM", customAttributes: nil)
        } else {
            MainViewController.aggressiveSwitchState = false
            UserDefaults.standard.set(MainViewController.aggressiveSwitchState, forKey: "aggressiveSwitchState")
            Answers.logCustomEvent(withName: "User Disabled Aggressive TM", customAttributes: nil)
        }
        
        for crypto in MainViewController.cryptoDic {
            UltimateAverageIndicator().calculateUltimate(crypto)
        }
    }
    
    @IBAction func agressiveInfoButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.20) {
            self.aggressiveInfoButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.aggressiveInfoButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        aggressiveInfoAlert(title: "Aggressive Trading Mode 😈", message: "A radical version of our algorithm that provides earlier buy and sell positions. Visit the Info Page for more details.")
        Answers.logCustomEvent(withName: "User Clicked Agressive Info Button", customAttributes: nil)
    }
    func aggressiveInfoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Info Page", style: UIAlertActionStyle.default, handler: { (action) in
            let infoViewController = self.storyboard?.instantiateViewController(withIdentifier: "infoViewController")
            self.present(infoViewController!, animated: true)
            Answers.logCustomEvent(withName: "User Clicked Info Button", customAttributes: nil)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func segmentedControlAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
    }
    
    //Segmented Control for crypto selection
    //---------------------------------------
    @IBAction func cryptoSelectorTapped(_ sender: Any) {
        switch cryptoSelector.selectedSegmentIndex {
        case 0:
            SettingsViewController.cell1 = true
            SettingsViewController.cell2 = false
            SettingsViewController.cell3 = false
            SettingsViewController.cell4 = false
            SettingsViewController.cell5 = false
        case 1:
            SettingsViewController.cell1 = false
            SettingsViewController.cell2 = true
            SettingsViewController.cell3 = false
            SettingsViewController.cell4 = false
            SettingsViewController.cell5 = false
        case 2:
            SettingsViewController.cell1 = false
            SettingsViewController.cell2 = false
            SettingsViewController.cell3 = true
            SettingsViewController.cell4 = false
            SettingsViewController.cell5 = false
        case 3:
            SettingsViewController.cell1 = false
            SettingsViewController.cell2 = false
            SettingsViewController.cell3 = false
            SettingsViewController.cell4 = true
            SettingsViewController.cell5 = false
        case 4:
            SettingsViewController.cell1 = false
            SettingsViewController.cell2 = false
            SettingsViewController.cell3 = false
            SettingsViewController.cell4 = false
            SettingsViewController.cell5 = true
        default:
            break
        }
        aggressiveInfoAlert(title: "Coming Soon 🙃", message: "CryptoGO is not able to analyze every cryptocurrency market yet.")
        //let settingsPickerViewController = self.storyboard?.instantiateViewController(withIdentifier: "settingsPickerViewController")
        //self.present(settingsPickerViewController!, animated: true)
    }
    
    //Segmented Control for currency selection
    //-----------------------------------------
    @IBAction func segmentedControlTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            SettingsViewController.currencyCode = "en_US"
            SettingsViewController.currencySymbol = "USD"
            SettingsViewController.currencyLogo = "$"
            
            Answers.logCustomEvent(withName: "User Clicked $", customAttributes: nil)
        case 1:
            SettingsViewController.currencyCode = "fr_FR"
            SettingsViewController.currencySymbol = "EUR"
            SettingsViewController.currencyLogo = "€"
            
            Answers.logCustomEvent(withName: "User Clicked €", customAttributes: nil)
        case 2:
            SettingsViewController.currencyCode = "en_GB"
            SettingsViewController.currencySymbol = "GBP"
            SettingsViewController.currencyLogo = "£"
            
            Answers.logCustomEvent(withName: "User Clicked £", customAttributes: nil)
        case 3:
            SettingsViewController.currencyCode = "zh-Hans-CN"
            SettingsViewController.currencySymbol = "CNY"
            SettingsViewController.currencyLogo = "¥"
            
            Answers.logCustomEvent(withName: "User Clicked ¥", customAttributes: nil)
        case 4:
            SettingsViewController.currencyCode = "ru_RU"
            SettingsViewController.currencySymbol = "RUB"
            SettingsViewController.currencyLogo = "₽"
            
            Answers.logCustomEvent(withName: "User Clicked ₽", customAttributes: nil)
        default:
            break
        }
        UserDefaults.standard.set(SettingsViewController.currencyCode, forKey: "currencyCode")
        UserDefaults.standard.set(SettingsViewController.currencySymbol, forKey: "currencySymbol")
        UserDefaults.standard.set(SettingsViewController.currencyLogo, forKey: "currencyLogo")
        UserDefaults.standard.set(segmentedControl.selectedSegmentIndex, forKey: "selectedSegment")
    }
    //-----------------------------------------
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        let infoViewController = self.storyboard?.instantiateViewController(withIdentifier: "infoViewController")
        self.present(infoViewController!, animated: true)
    }
    
    
}
