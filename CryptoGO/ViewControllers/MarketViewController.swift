//
//  MarketViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 22/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import Answers

class MarketViewController: UIViewController, UITextFieldDelegate {
    
    static var marketUp: Int = 0
    static var marketStable: Int = 0
    static var marketDown: Int = 0
    
    static var holdButton: Int = 0
    static var buyButton: Int = 0
    static var sellButton: Int = 0
    
    static var cgoTokens: Double = 0
    
    static var elapsedTime: Double = 0
    static var remainingTime: String = ""
    static var remainingSomething = true
    
    var allowForecast = true
    
    @IBOutlet weak var forecastLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var marketTrendSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var holdButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    
    @IBOutlet weak var bitcoinForecastTextfield: UITextField!
    
    
    override func viewDidLoad() {
        
        forecastLabel.text = "What will be the Bitcoin price in 30 minutes? \n Guess the exact \(SettingsViewController.currencyLogo) value and earn 500 CGO tokens!"
        
        super.viewDidLoad()
        
        bitcoinForecastTextfield.delegate = self
        
        registerForKeyboardNotifications()
        self.hideKeyboard()
        
        remainingTimeBeforeNextForecast(caller: "MarketVC")
        
        enableVoteSegment()
        resetVoteSelections()
        setButtonImage()
    }
    
    //Vote functions
    //---------------
    func resetVoteSelections() {
        MarketViewController.holdButton = 0
        MarketViewController.buyButton = 0
        MarketViewController.sellButton = 0
        MarketViewController.marketDown = 0
        MarketViewController.marketUp = 0
    }
    func setButtonImage() {
        if MarketViewController.holdButton == 1 {
            holdButton.setImage(UIImage(named: "Badge-hold"), for: UIControlState.normal)
        } else {
            holdButton.setImage(UIImage(named: "Disabled-Hold"), for: UIControlState.normal)
        }
        if MarketViewController.buyButton == 1 {
            buyButton.setImage(UIImage(named: "Badge-buy"), for: UIControlState.normal)
        } else {
            buyButton.setImage(UIImage(named: "Disabled-Buy"), for: UIControlState.normal)
        }
        if MarketViewController.sellButton == 1 {
            sellButton.setImage(UIImage(named: "Badge-sell"), for: UIControlState.normal)
        } else {
            sellButton.setImage(UIImage(named: "Disabled-Sell"), for: UIControlState.normal)
        }
    }
    func enableVoteSegment() {
        
        var buttonClicked: Bool = false
        var segmentedClicked: Bool = false
        
        if MarketViewController.holdButton == 1 || MarketViewController.buyButton == 1 || MarketViewController.sellButton == 1 {
            buttonClicked = true
        }
        if MarketViewController.marketDown == 1 || MarketViewController.marketStable == 1 || MarketViewController.marketUp == 1{
            segmentedClicked = true
        }
        
        if buttonClicked == true && segmentedClicked == true {
            segmentedControl.setEnabled(true, forSegmentAt: 1)
        } else {
            segmentedControl.setEnabled(false, forSegmentAt: 1)
        }
    }
    func vote() {
        
        sendPATCHRequest()
        
        Answers.logCustomEvent(withName: "User Voted", customAttributes: nil)
        
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "lastVoteDate")
        
        if UserDefaults.standard.object(forKey: "cgoTokens") != nil {
            let lastCGOTokensAmount = UserDefaults.standard.double(forKey: "cgoTokens")
            MarketViewController.cgoTokens = lastCGOTokensAmount + 5
            UserDefaults.standard.set(MarketViewController.cgoTokens, forKey: "cgoTokens")
        } else {
            MarketViewController.cgoTokens = 5
            UserDefaults.standard.set(MarketViewController.cgoTokens, forKey: "cgoTokens")
        }
        
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController")
        self.present(mainViewController!, animated: true)
    }
    
    //POST to API
    //------------
    func sendPATCHRequest() {
        
        let dict : [String : Int] = ["votesId": 1,
                                     "vote_nb": 1,
                                     "current_time": 0,
                                     "trend_up": MarketViewController.marketUp,
                                     "trend_stable": MarketViewController.marketStable,
                                     "trend_down": MarketViewController.marketDown,
                                     "position_hold": MarketViewController.holdButton,
                                     "position_buy": MarketViewController.buyButton,
                                     "position_sell": MarketViewController.sellButton]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            
            guard let url = NSURL(string: "https://4wo0x5dun1.execute-api.eu-west-3.amazonaws.com/prod/patch") else { return }
            let request = NSMutableURLRequest(url: url as URL)

            request.httpMethod = "PATCH"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("0k5bOopsuu2NnTRbBFsgR5ZYDwGnrlBr7SQKNpKh", forHTTPHeaderField: "X-API-KEY")
            request.addValue("application/json", forHTTPHeaderField: "Credential")
            request.addValue("application/json", forHTTPHeaderField: "Signature")
            request.addValue("application/json", forHTTPHeaderField: "SignedHeaders")
            request.addValue("application/json", forHTTPHeaderField: "Date")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json {
                        let resultValue = parseJSON["success"]
                        print("result: \(String(describing: resultValue))")
                        print(parseJSON)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    //Textfield functions
    //--------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:".0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var forecastSaved = false
        
        if textField == bitcoinForecastTextfield {
            if bitcoinForecastTextfield.text != "" {
                if allowForecast == true {
                    
                    let str = bitcoinForecastTextfield.text
                    
                    if str != "" {
                        let double = Double(str!)
                        UserDefaults.standard.set(double, forKey: "bitcoinForecastPrice")
                    }
                    
                    let currentDate = Date()
                    UserDefaults.standard.set(currentDate, forKey: "lastForecast")
                    
                    forecastSaved = true
                    MarketViewController.remainingSomething = true
                    
                    getLastForecast()
                }
            }
        }
        
        bitcoinForecastTextfield.resignFirstResponder()
        
        if forecastSaved == true {
            forecastAlert(title: "Good guess?", message: "🤞")
        }
        return true
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        bitcoinForecastTextfield.text = ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == bitcoinForecastTextfield {
            if allowForecast == false {
                
                remainingTimeBeforeNextForecast(caller: "MarketVC")
                let remainingSeconds = 1800 - MarketViewController.elapsedTime
                
                if remainingSeconds <= 0 {
                    forecastResult()
                } else {
                    forecastAlert(title: "Too soon 😋", message: "Come back in \(MarketViewController.remainingTime) to know if you guessed the price right!")
                }
            }
        }
    }

    //Forecast Functions
    //------------------
    func remainingTimeBeforeNextForecast(caller: String) {
        getLastForecast()
        
        let remainingSeconds = 1800 - MarketViewController.elapsedTime
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .brief
        
        let formattedString = formatter.string(from: TimeInterval(remainingSeconds))!
        
        MarketViewController.remainingTime = formattedString
        
        if caller == "MarketVC" {
            if remainingSeconds <= 0 {
                forecastResult()
            }
        } else if caller == "MainVC" {
            if remainingSeconds <= 0 {
                if UserDefaults.standard.object(forKey: "bitcoinForecastPrice") != nil {
                    MarketViewController.remainingSomething = false
                } else {
                    MarketViewController.remainingSomething = true
                }
            }
        }
    }
    
    func getLastForecast() {
        
        let currentDate = Date()
        var lastDataRefresh: Date?
        var timeSinceLastRefresh: TimeInterval?
        
        if UserDefaults.standard.object(forKey: "lastForecast") != nil {
            lastDataRefresh = UserDefaults.standard.value(forKey: "lastForecast") as? Date
            
            let eTime = (currentDate.timeIntervalSince(lastDataRefresh!))
            MarketViewController.elapsedTime = Double(eTime)

            timeSinceLastRefresh = (currentDate.timeIntervalSince(lastDataRefresh!)) / 1800
            let doubleLastRefresh = Double(timeSinceLastRefresh!)
            
            if doubleLastRefresh < 1 {
                allowForecast = false
            } else {
                allowForecast = true
            }
        } else {
            allowForecast = true
        }
    }
    
    func forecastResult() {
        
        var forecastPrice = 0.0
        
        DispatchQueue.main.async(execute: {
            
            if UserDefaults.standard.object(forKey: "bitcoinForecastPrice") != nil {
                forecastPrice = (UserDefaults.standard.double(forKey: "bitcoinForecastPrice") - 2.38) //to censor!!!
                
                guard let bitcoinPrice = CryptoInfo.cryptoPriceDic["bitcoin"] else { return }
                
                print("forecastPrice", forecastPrice)
                
                if forecastPrice == bitcoinPrice {
                    self.forecastAlert(title: "Congratulations! 🎉", message: "You guessed the Bitcoin price correctly and earned 500 CGO tokens!")
                    
                    Answers.logCustomEvent(withName: "User Earned 500CGO Tokens!", customAttributes: nil)
                    
                    UserDefaults.standard.removeObject(forKey: "bitcoinForecastPrice")
                    MainViewController.alertCount = 0
                    
                    if UserDefaults.standard.object(forKey: "cgoTokens") != nil {
                        let lastCGOTokensAmount = UserDefaults.standard.double(forKey: "cgoTokens")
                        MarketViewController.cgoTokens = lastCGOTokensAmount + 500
                        UserDefaults.standard.set(MarketViewController.cgoTokens, forKey: "cgoTokens")
                    } else {
                        MarketViewController.cgoTokens = 500
                        UserDefaults.standard.set(MarketViewController.cgoTokens, forKey: "cgoTokens")
                    }
                } else {
                    self.forecastAlert(title: "Sorry 😢", message: "Your guess was not right this time but you can try again!")
                    
                    UserDefaults.standard.removeObject(forKey: "bitcoinForecastPrice")
                    MainViewController.alertCount = 0
                }
            }
        })
    }
    
    // Alert
    //------
    func forecastAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Keyboard Functions
    //---------------------
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWasShown(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo,
            let keyboardFrameValue = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue
            else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
       let contentInsets = UIEdgeInsets.zero
       scrollView.contentInset = contentInsets
       scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //Buttons
    //----------
    @IBAction func holdButtonTapped(_ sender: Any) {
        MarketViewController.holdButton = 1
        MarketViewController.buyButton = 0
        MarketViewController.sellButton = 0
        enableVoteSegment()
        setButtonImage()
    }
    @IBAction func buyButtonTapped(_ sender: Any) {
        MarketViewController.holdButton = 0
        MarketViewController.buyButton = 1
        MarketViewController.sellButton = 0
        enableVoteSegment()
        setButtonImage()
    }
    @IBAction func sellButtonTapped(_ sender: Any) {
        MarketViewController.holdButton = 0
        MarketViewController.buyButton = 0
        MarketViewController.sellButton = 1
        enableVoteSegment()
        setButtonImage()
    }
    
    //Segmented controls
    //-------------------
    @IBAction func segmentedControlTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.dismiss(animated: true, completion: nil)
            resetVoteSelections()
        case 1:
            vote()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VoteAlert"), object: nil)
        default:
            break
        }
    }
    @IBAction func marketTrendSegmentedControlTapped(_ sender: Any) {
        switch marketTrendSegmentedControl.selectedSegmentIndex
        {
        case 0:
            MarketViewController.marketDown = 1
            MarketViewController.marketStable = 0
            MarketViewController.marketUp = 0
        case 1:
            MarketViewController.marketDown = 0
            MarketViewController.marketStable = 1
            MarketViewController.marketUp = 0
        case 2:
            MarketViewController.marketDown = 0
            MarketViewController.marketStable = 0
            MarketViewController.marketUp = 1
        default:
            break
        }
        enableVoteSegment()
    }

    
}
