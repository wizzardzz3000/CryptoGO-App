//
//  Notifications.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 02/01/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationsFunctions: MainViewController {
    /*
     
    func bitcoinNotifications() {
        if MainViewController.bitcoinNotificationSwitchState == true {
            if MainViewController.aggressiveSwitchState == false {
                if UltimateAverageIndicator.ultimateBitcoinIndicator > 1 && CryptoRelativeStrengthIndex.bitcoinRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Bitcoins!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateBitcoinIndicator < 1 && CryptoRelativeStrengthIndex.bitcoinRSI < 32 && CryptoRelativeStrengthIndex.bitcoinRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Bitcoins!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            } else {
                if UltimateAverageIndicator.ultimateBitcoinIndicator > 18.0 && CryptoRelativeStrengthIndex.bitcoinRSI > 56.0 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Bitcoins!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateBitcoinIndicator < 2.5 && CryptoRelativeStrengthIndex.bitcoinRSI < 42 && CryptoRelativeStrengthIndex.bitcoinRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Bitcoins!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
        print("bitcoinNotifications function was triggered")
    }
    func bitcoinCashNotifications() {
        if MainViewController.bitcoinCashNotificationSwitchState == true {
            if MainViewController.aggressiveSwitchState == false {
                if UltimateAverageIndicator.ultimateBitcoinCashIndicator > 1 && BitcoinCashRelativeStrengthIndex.bitcoinCashRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Bitcoin Cash!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateBitcoinCashIndicator < 1 && BitcoinCashRelativeStrengthIndex.bitcoinCashRSI < 32 && BitcoinCashRelativeStrengthIndex.bitcoinCashRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Bitcoin Cash!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            } else {
                if UltimateAverageIndicator.ultimateBitcoinCashIndicator > 18.0 && BitcoinCashRelativeStrengthIndex.bitcoinCashRSI > 56.0 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Bitcoin Cash!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateBitcoinCashIndicator < 2.5 && BitcoinCashRelativeStrengthIndex.bitcoinCashRSI < 42 && BitcoinCashRelativeStrengthIndex.bitcoinCashRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Bitcoin Cash!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
        print("bitcoinCashNotifications function was triggered")
    }
    func ethereumNotifications() {
        if MainViewController.ethereumNotificationSwitchState == true {
            if MainViewController.aggressiveSwitchState == false {
                if UltimateAverageIndicator.ultimateEthereumIndicator > 21.5 && EthereumRelativeStrengthIndex.ethereumRSI > 70 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Ethereum!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateEthereumIndicator < 1 && EthereumRelativeStrengthIndex.ethereumRSI < 32 && EthereumRelativeStrengthIndex.ethereumRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Ethereum!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            } else {
                if UltimateAverageIndicator.ultimateEthereumIndicator > 18.0 && EthereumRelativeStrengthIndex.ethereumRSI > 56.0 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Ethereum!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateEthereumIndicator < 2.5 && EthereumRelativeStrengthIndex.ethereumRSI < 42 && EthereumRelativeStrengthIndex.ethereumRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Ethereum!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
        print("ethereumNotifications function was triggered")
    }
    func litecoinNotifications() {
        if MainViewController.litecoinNotificationSwitchState == true {
            if MainViewController.aggressiveSwitchState == false {
                if UltimateAverageIndicator.ultimateLitecoinIndicator > 21.5 && LitecoinRelativeStrengthIndex.litecoinRSI > 70 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Litecoins!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateLitecoinIndicator < 1 && LitecoinRelativeStrengthIndex.litecoinRSI < 32 && LitecoinRelativeStrengthIndex.litecoinRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Litecoins!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            } else {
                if UltimateAverageIndicator.ultimateLitecoinIndicator > 18.0 && LitecoinRelativeStrengthIndex.litecoinRSI > 56.0 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Litecoins!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateLitecoinIndicator < 2.5 && LitecoinRelativeStrengthIndex.litecoinRSI < 42 && LitecoinRelativeStrengthIndex.litecoinRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Litecoins!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
        print("litecoinNotifications function was triggered")
    }
    func rippleNotifications() {
        if MainViewController.rippleNotificationSwitchState == true {
            if MainViewController.aggressiveSwitchState == false {
                if UltimateAverageIndicator.ultimateRippleIndicator > 21.5 && RippleRelativeStrengthIndex.rippleRSI > 70 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Ripple!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateRippleIndicator < 1 && RippleRelativeStrengthIndex.rippleRSI < 32 && RippleRelativeStrengthIndex.rippleRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Ripple!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            } else {
                if UltimateAverageIndicator.ultimateRippleIndicator > 18.0 && RippleRelativeStrengthIndex.rippleRSI > 56.0 {
                    let content = UNMutableNotificationContent()
                    content.title = "Sell Ripple!"
                    content.body = "Prices are high and we think you should sell before they go down again."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else if UltimateAverageIndicator.ultimateRippleIndicator < 2.5 && RippleRelativeStrengthIndex.rippleRSI < 42 && RippleRelativeStrengthIndex.rippleRSI > 1 {
                    let content = UNMutableNotificationContent()
                    content.title = "Buy Ripple!"
                    content.body = "Prices are low enough to buy right now. Don’t miss a good buying opportunity."
                    content.badge = 1
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: "TradeTime", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
        print("rippleNotifications function was triggered")
    }
 
    
    //------------------
    // Switches actions
    //------------------
    
    // ---> Notifications switches
    //-----------------------------
    @IBAction func bitcoinNotificationSwitchTapped(_ sender: UISwitch) {
        if bitcoinNotificationSwitch.isOn {
            MainViewController.bitcoinNotificationSwitchState = true
            UserDefaults.standard.set(MainViewController.bitcoinNotificationSwitchState, forKey: "btcNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Enabled BTC Notifications", customAttributes: nil)
        } else {
            MainViewController.bitcoinNotificationSwitchState = false
            UserDefaults.standard.set(MainViewController.bitcoinNotificationSwitchState, forKey: "btcNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Disabled BTC Notifications", customAttributes: nil)
        }
    }
    @IBAction func bitcoinCashNotificationSwitchTapped(_ sender: UISwitch) {
        if bitcoinCashNotificationSwitch.isOn {
            MainViewController.bitcoinCashNotificationSwitchState = true
            UserDefaults.standard.set(MainViewController.bitcoinCashNotificationSwitchState, forKey: "bchNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Enabled BCH Notifications", customAttributes: nil)
        } else {
            MainViewController.bitcoinCashNotificationSwitchState = false
            UserDefaults.standard.set(MainViewController.bitcoinCashNotificationSwitchState, forKey: "bchNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Disabled BCH Notifications", customAttributes: nil)
        }
    }
    @IBAction func ethereumNotificationSwitchTapped(_ sender: UISwitch) {
        if ethereumNotificationSwitch.isOn {
            MainViewController.ethereumNotificationSwitchState = true
            UserDefaults.standard.set(MainViewController.ethereumNotificationSwitchState, forKey: "ethNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Enabled ETH Notifications", customAttributes: nil)
        } else {
            MainViewController.ethereumNotificationSwitchState = false
            UserDefaults.standard.set(MainViewController.ethereumNotificationSwitchState, forKey: "ethNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Disabled ETH Notifications", customAttributes: nil)
        }
    }
    @IBAction func litecoinNotificationSwitchTapped(_ sender: UISwitch) {
        if litecoinNotificationSwitch.isOn {
            MainViewController.litecoinNotificationSwitchState = true
            UserDefaults.standard.set(MainViewController.litecoinNotificationSwitchState, forKey: "ltcNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Enabled LTC Notifications", customAttributes: nil)
        } else {
            MainViewController.litecoinNotificationSwitchState = false
            UserDefaults.standard.set(MainViewController.litecoinNotificationSwitchState, forKey: "ltcNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Disabled LTC Notifications", customAttributes: nil)
        }
    }
    @IBAction func rippleNotificationSwitchTapped(_ sender: UISwitch) {
        if rippleNotificationSwitch.isOn {
            MainViewController.rippleNotificationSwitchState = true
            UserDefaults.standard.set(MainViewController.rippleNotificationSwitchState, forKey: "xrpNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Enabled XRP Notifications", customAttributes: nil)
        } else {
            MainViewController.rippleNotificationSwitchState = false
            UserDefaults.standard.set(MainViewController.rippleNotificationSwitchState, forKey: "xrpNotificationSwitchState")
            Answers.logCustomEvent(withName: "User Disabled XRP Notifications", customAttributes: nil)
        }
    }
 */
    
}
