//
//  MainViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 18/12/2017.
//  Copyright © 2017 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Crashlytics
import Answers
import StoreKit


class MainViewController: UIViewController {
    
    static var bitcoinPriceString: String = ""
    static var bitcoinPercentageChangeString: String = ""
    static var bitcoinCashPriceString: String = ""
    static var bitcoinCashPercentageChangeString: String = ""
    static var ethereumPriceString: String = ""
    static var ethereumPercentageChangeString: String = ""
    static var litecoinPriceString: String = ""
    static var litecoinPercentageChangeString: String = ""
    static var ripplePriceString: String = ""
    static var ripplePercentageChangeString: String = ""

    static var mainWalletValue : Double = 0
    
    static var alertCount = 0
    static var lastVote = 0.0
    
    // Don't touch
    static var crypto1 = "bitcoin"
    static var crypto2 = "bitcoinCash"
    static var crypto3 = "ethereum"
    static var crypto4 = "litecoin"
    static var crypto5 = "ripple"
    
    static var cryptoDic = [crypto1, crypto2, crypto3, crypto4, crypto5]
    
    static var bitcoinNotificationSwitchState: Bool = false
    static var bitcoinCashNotificationSwitchState: Bool = false
    static var ethereumNotificationSwitchState: Bool = false
    static var litecoinNotificationSwitchState: Bool = false
    static var rippleNotificationSwitchState: Bool = false
    static var aggressiveSwitchState: Bool = false
    
    static var buyBTCPosition : Bool = false
    static var buyBCHPosition : Bool = false
    static var buyETHPosition : Bool = false
    static var buyLTCPosition : Bool = false
    static var buyXRPPosition : Bool = false
    
    static var sellBTCPosition : Bool = false
    static var sellBCHPosition : Bool = false
    static var sellETHPosition : Bool = false
    static var sellLTCPosition : Bool = false
    static var sellXRPPosition : Bool = false
    
    static var voteButtonEnabled = false

    @IBOutlet weak var bitcoinData: UILabel!
    @IBOutlet weak var bitcoinCashData: UILabel!
    @IBOutlet weak var ethereumData: UILabel!
    @IBOutlet weak var litecoinData: UILabel!
    @IBOutlet weak var rippleData: UILabel!
    
    @IBOutlet weak var bitcoinDifference: UILabel!
    @IBOutlet weak var bitcoinCashDifference: UILabel!
    @IBOutlet weak var ethereumDifference: UILabel!
    @IBOutlet weak var litecoinDifference: UILabel!
    @IBOutlet weak var rippleDifference: UILabel!
    
    @IBOutlet weak var bitcoinBadgeButton: UIButton!
    @IBOutlet weak var ethereumBadgeButton: UIButton!
    @IBOutlet weak var litecoinBadgeButton: UIButton!
    @IBOutlet weak var bitcoinCashBadgeButton: UIButton!
    @IBOutlet weak var rippleBadgeButton: UIButton!
    
    @IBOutlet weak var bitcoinHoldAnimateBadge: UIImageView!
    @IBOutlet weak var bitcoinCashHoldAnimatedBadge: UIImageView!
    @IBOutlet weak var ethereumHoldAnimatedBadge: UIImageView!
    @IBOutlet weak var litecoinHoldAnimatedBadge: UIImageView!
    @IBOutlet weak var rippleHoldAnimatedBadge: UIImageView!
    
    // Don't touch
    @IBOutlet weak var bitcoinNotificationSwitch: UISwitch!
    @IBOutlet weak var bitcoinCashNotificationSwitch: UISwitch!
    @IBOutlet weak var ethereumNotificationSwitch: UISwitch!
    @IBOutlet weak var litecoinNotificationSwitch: UISwitch!
    @IBOutlet weak var rippleNotificationSwitch: UISwitch!
    
    @IBOutlet weak var walletValue: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var communityButton: UIButton!
    
    @IBOutlet weak var marketButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var roundCommunityButton: UIButton!
    @IBOutlet weak var roundTrendButton: UIButton!
    @IBOutlet weak var roundPositionButton: UIButton!
    
    @IBOutlet weak var votesTrend: UIButton!
    @IBOutlet weak var votesPosition: UIButton!
    
    static var buyPositionDict : [String : Bool] =
        
        ["bitcoin": MainViewController.buyBTCPosition,
         "bitcoinCash": MainViewController.buyBCHPosition,
         "ethereum": MainViewController.buyETHPosition,
         "litecoin": MainViewController.buyLTCPosition,
         "ripple": MainViewController.buyXRPPosition]
    
    static var sellPositionDict : [String : Bool] =
        
        ["bitcoin": MainViewController.sellBTCPosition,
         "bitcoinCash": MainViewController.sellBCHPosition,
         "ethereum": MainViewController.sellETHPosition,
         "litecoin": MainViewController.sellLTCPosition,
         "ripple": MainViewController.sellXRPPosition]
    
    static var firstBuyDict : [String : String] =
        
        ["bitcoin": "firstBTCBuyPrice-\(SettingsViewController.currencyCode)",
         "bitcoinCash": "firstBCHBuyPrice-\(SettingsViewController.currencyCode)",
         "ethereum": "firstETHBuyPrice-\(SettingsViewController.currencyCode)",
         "litecoin": "firstLTCBuyPrice-\(SettingsViewController.currencyCode)",
         "ripple": "firstXRPBuyPrice-\(SettingsViewController.currencyCode)"]
    
    static var firstSellDict : [String : String] =
        
        ["bitcoin": "firstBTCSellPrice-\(SettingsViewController.currencyCode)",
         "bitcoinCash": "firstBCHSellPrice-\(SettingsViewController.currencyCode)",
         "ethereum": "firstETHSellPrice-\(SettingsViewController.currencyCode)",
         "litecoin": "firstLTCSellPrice-\(SettingsViewController.currencyCode)",
         "ripple": "firstXRPSellPrice-\(SettingsViewController.currencyCode)"]
    
    // ---> ViewDidLoad
    //---------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelsAppear()
        stackViewAppears()
        loadSwitchesState()
        
        toggleVoteButtonAvailability()
      
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        //Refresh Control
        let offset = -110
        let color = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: CGFloat(offset), width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        refreshControl.attributedTitle = NSAttributedString(string: "", attributes: color)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.voteAlert), name:NSNotification.Name(rawValue: "VoteAlert"), object: nil)

    }
    
    // ---> ViewWillAppear
    //---------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toggleVoteButtonAvailability()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.holdBadgesAnimation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.holdBadgesAnimation), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUIs), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUIs), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.slowlySetAnimatedBadgesOpacityToZero), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        updateUIs()
        
        setAnimatedBadgesOpacityToZero()
    }
    
    //----------------------------------------------------------
    // Set locale currency (on first app's launch after install)
    //----------------------------------------------------------
    func setLocaleCurrency() {
        
        if let currencyCode = UserDefaults.standard.object(forKey: "currencyCode") as? String {
            SettingsViewController.currencyCode = currencyCode
        }
        if let currencySymbol = UserDefaults.standard.object(forKey: "currencySymbol") as? String {
            SettingsViewController.currencySymbol = currencySymbol
        }
        if let currencyLogo = UserDefaults.standard.object(forKey: "currencyLogo") as? String {
            SettingsViewController.currencyLogo = currencyLogo
        }
        
        if SettingsViewController.currencyLogo == "" {
            
            let locale = Locale.current
            let currencyCode = locale.currencyCode!
            
            if currencyCode == "EUR" {
                SettingsViewController.currencyCode = "fr_FR"
                SettingsViewController.currencySymbol = "EUR"
                SettingsViewController.currencyLogo = "€"
                
            } else if currencyCode == "GBP" {
                SettingsViewController.currencyCode = "en_GB"
                SettingsViewController.currencySymbol = "GBP"
                SettingsViewController.currencyLogo = "£"
                
            } else if currencyCode == "CNY" {
                SettingsViewController.currencyCode = "zn-Hans-CN"
                SettingsViewController.currencySymbol = "CNY"
                SettingsViewController.currencyLogo = "¥"
                
            } else if currencyCode == "RUB" {
                SettingsViewController.currencyCode = "ru_RU"
                SettingsViewController.currencySymbol = "RUB"
                SettingsViewController.currencyLogo = "₽"
                
            } else {
                SettingsViewController.currencyCode = "en_US"
                SettingsViewController.currencySymbol = "USD"
                SettingsViewController.currencyLogo = "$"
            }
            
            UserDefaults.standard.set(SettingsViewController.currencyCode, forKey: "currencyCode")
            UserDefaults.standard.set(SettingsViewController.currencySymbol, forKey: "currencySymbol")
            UserDefaults.standard.set(SettingsViewController.currencyLogo, forKey: "currencyLogo")
        }
    }
    
    //---------------------
    // Load switches state
    //---------------------
    func loadSwitchesState() {
        /*
        if let btcNotificationSwitchState = UserDefaults.standard.object(forKey: "btcNotificationSwitchState") as? Bool {
            MainViewController.bitcoinNotificationSwitchState = btcNotificationSwitchState
            if MainViewController.bitcoinNotificationSwitchState == true {
                bitcoinNotificationSwitch.isOn = true
            }
        }
        if let bchNotificationSwitchState = UserDefaults.standard.object(forKey: "bchNotificationSwitchState") as? Bool {
            MainViewController.bitcoinCashNotificationSwitchState = bchNotificationSwitchState
            if MainViewController.bitcoinCashNotificationSwitchState == true {
                bitcoinCashNotificationSwitch.isOn = true
            }
        }
        if let ethNotificationSwitchState = UserDefaults.standard.object(forKey: "ethNotificationSwitchState") as? Bool {
            MainViewController.ethereumNotificationSwitchState = ethNotificationSwitchState
            if MainViewController.ethereumNotificationSwitchState == true {
                ethereumNotificationSwitch.isOn = true
            }
        }
        if let ltcNotificationSwitchState = UserDefaults.standard.object(forKey: "ltcNotificationSwitchState") as? Bool {
            MainViewController.litecoinNotificationSwitchState = ltcNotificationSwitchState
            if MainViewController.litecoinNotificationSwitchState == true {
                litecoinNotificationSwitch.isOn = true
            }
        }
        if let xrpNotificationSwitchState = UserDefaults.standard.object(forKey: "xrpNotificationSwitchState") as? Bool {
            MainViewController.rippleNotificationSwitchState = xrpNotificationSwitchState
            if MainViewController.rippleNotificationSwitchState == true {
                rippleNotificationSwitch.isOn = true
            }
        }
        */
    }
    
    //----------------------
    // Animations Functions
    //----------------------
    
    // ---> Initializations to Zero
    //------------------------------
    @objc func setAnimatedBadgesOpacityToZero() {
            let bitcoinBadge = bitcoinHoldAnimateBadge
            let bitcoinCashBadge = bitcoinCashHoldAnimatedBadge
            let ethereumBadge = ethereumHoldAnimatedBadge
            let litecoinBadge = litecoinHoldAnimatedBadge
            let rippleBadge = rippleHoldAnimatedBadge
            bitcoinBadge?.alpha = 0
            bitcoinCashBadge?.alpha = 0
            ethereumBadge?.alpha = 0
            litecoinBadge?.alpha = 0
            rippleBadge?.alpha = 0
    }
    @objc func slowlySetAnimatedBadgesOpacityToZero() {
        UIView.animate(withDuration:1.0) {
            let bitcoinBadge = self.bitcoinHoldAnimateBadge
            let bitcoinCashBadge = self.bitcoinCashHoldAnimatedBadge
            let ethereumBadge = self.ethereumHoldAnimatedBadge
            let litecoinBadge = self.litecoinHoldAnimatedBadge
            let rippleBadge = self.rippleHoldAnimatedBadge
            bitcoinBadge?.alpha = 0
            bitcoinCashBadge?.alpha = 0
            ethereumBadge?.alpha = 0
            litecoinBadge?.alpha = 0
            rippleBadge?.alpha = 0
        }
    }
    func labelsAppear() {
        UIView.animate(withDuration:0.0) {
            let bitcoin = self.bitcoinData
            let bitcoinCash = self.bitcoinCashData
            let ethereum = self.ethereumData
            let litecoin = self.litecoinData
            let ripple = self.rippleData
            bitcoin?.alpha = 0
            bitcoinCash?.alpha = 0
            ethereum?.alpha = 0
            litecoin?.alpha = 0
            ripple?.alpha = 0
        }
        UIView.animate(withDuration:0.0) {
            let wallet = self.walletValue
            wallet?.alpha = 0
        }
        UIView.animate(withDuration:0.0) {
            let bitcoinDifference = self.bitcoinDifference
            let bitcoinCashDifference = self.bitcoinCashDifference
            let ethereumDifference = self.ethereumDifference
            let litecoinDifference = self.litecoinDifference
            let rippleDifference = self.rippleDifference
            bitcoinDifference?.alpha = 0
            bitcoinCashDifference?.alpha = 0
            ethereumDifference?.alpha = 0
            litecoinDifference?.alpha = 0
            rippleDifference?.alpha = 0
        }
        updateDataDelayTimer()
        updateWalletDelayTimer()
        updateDifferenceDelayTimer()
    }
    
    // ---> App start appearence flow (stackView -> data -> difference -> wallet)
    //---------------------------------------------------------------------------
    func stackViewAppears() {
        UIView.animate(withDuration:0.0) {
        let stackView = self.stackView
        stackView?.alpha = 0
        }
        UIView.animate(withDuration:1.0) {
            let stackView = self.stackView
            stackView?.alpha = 1
        }
    }
    @objc func dataAppear() {
        UIView.animate(withDuration:2.25) {
            let bitcoin = self.bitcoinData
            let bitcoinCash = self.bitcoinCashData
            let ethereum = self.ethereumData
            let litecoin = self.litecoinData
            let ripple = self.rippleData
            bitcoin?.alpha = 0; bitcoin?.alpha = 1
            bitcoinCash?.alpha = 0; bitcoinCash?.alpha = 1
            ethereum?.alpha = 0; ethereum?.alpha = 1
            litecoin?.alpha = 0; litecoin?.alpha = 1
            ripple?.alpha = 0; ripple?.alpha = 1
        }
    }
    @objc func differenceAppear() {
        UIView.animate(withDuration:2.25) {
            let bitcoinDifference = self.bitcoinDifference
            let bitcoinCashDifference = self.bitcoinCashDifference
            let ethereumDifference = self.ethereumDifference
            let litecoinDifference = self.litecoinDifference
            let rippleDifference = self.rippleDifference
            bitcoinDifference?.alpha = 0; bitcoinDifference?.alpha = 1
            bitcoinCashDifference?.alpha = 0; bitcoinCashDifference?.alpha = 1
            ethereumDifference?.alpha = 0; ethereumDifference?.alpha = 1
            litecoinDifference?.alpha = 0; litecoinDifference?.alpha = 1
            rippleDifference?.alpha = 0; rippleDifference?.alpha = 1
        }
    }
    @objc func walletAppear() {
        UIView.animate(withDuration:2.25) {
            let wallet = self.walletValue
            wallet?.alpha = 0; wallet?.alpha = 1
        }
    }
    
    // ---> DelayTimers for appearence flow
    //--------------------------------------
    func updateDataDelayTimer() {
        let myTimer = Timer(timeInterval: 0.70, target: self, selector: #selector(dataAppear), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func updateDifferenceDelayTimer() {
        let myTimer = Timer(timeInterval: 1.40, target: self, selector: #selector(differenceAppear), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func updateWalletDelayTimer() {
        let myTimer = Timer(timeInterval: 2.00, target: self, selector: #selector(walletAppear), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    // ---> Hold badges animations
    //-----------------------------
    @objc func holdBadgesAnimation() {
        //Appears
        UIView.animate(withDuration:1.0) {
            let bitcoinBadge = self.bitcoinHoldAnimateBadge
            let bitcoinCashBadge = self.bitcoinCashHoldAnimatedBadge
            let ethereumBadge = self.ethereumHoldAnimatedBadge
            let litecoinBadge = self.litecoinHoldAnimatedBadge
            let rippleBadge = self.rippleHoldAnimatedBadge
            bitcoinBadge?.alpha = 0; bitcoinBadge?.alpha = 1
            bitcoinCashBadge?.alpha = 0; bitcoinCashBadge?.alpha = 1
            ethereumBadge?.alpha = 0; ethereumBadge?.alpha = 1
            litecoinBadge?.alpha = 0; litecoinBadge?.alpha = 1
            rippleBadge?.alpha = 0; rippleBadge?.alpha = 1
        }
        //Rotate
        var rotationAnimation = CABasicAnimation()
        rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: (Double.pi * 2.0))
        rotationAnimation.duration = 5.5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity
        
        bitcoinHoldAnimateBadge.layer.add(rotationAnimation, forKey: "rotationAnimation")
        bitcoinCashHoldAnimatedBadge.layer.add(rotationAnimation, forKey: "rotationAnimation")
        ethereumHoldAnimatedBadge.layer.add(rotationAnimation, forKey: "rotationAnimation")
        litecoinHoldAnimatedBadge.layer.add(rotationAnimation, forKey: "rotationAnimation")
        rippleHoldAnimatedBadge.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    // ---> Buy and sell badges animations + Animations stop
    //-------------------------------------------------------
    func buyAndSellAnimation(_ crypto: String) {
        
        let badgeButtonDict : [String : UIButton] =
            
            ["bitcoin": bitcoinBadgeButton,
             "bitcoinCash": bitcoinCashBadgeButton,
             "ethereum": ethereumBadgeButton,
             "litecoin": litecoinBadgeButton,
             "ripple": rippleBadgeButton]
        
        let badgeButt = badgeButtonDict[crypto]
        guard let badgeButton = badgeButt else { return }
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            if crypto == crypto {
                badgeButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.03)
                badgeButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.97)
            }
        }, completion: nil)
    }
    func stopCell1PreviousAnimation() {
        if bitcoinBadgeButton != nil {
            bitcoinBadgeButton.layer.removeAllAnimations()
        }
    }
    func stopCell2PreviousAnimation() {
        if bitcoinCashBadgeButton != nil {
            bitcoinCashBadgeButton.layer.removeAllAnimations()
        }
    }
    func stopCell3PreviousAnimation() {
        if ethereumBadgeButton != nil {
            ethereumBadgeButton.layer.removeAllAnimations()
        }
    }
    func stopCell4PreviousAnimation() {
        if litecoinBadgeButton != nil {
            litecoinBadgeButton.layer.removeAllAnimations()
        }
    }
    func stopCell5PreviousAnimation() {
        if rippleBadgeButton != nil {
            rippleBadgeButton.layer.removeAllAnimations()
        }
    }
    
    //------------------------------
    // Update and refresh functions
    //------------------------------
    @objc func updateUIs() {
        
        VotesFunctions().refreshVotesData()
        
        UpdateIndicators().refreshIndicatorsData()
        
        for crypto in MainViewController.cryptoDic {
            
            CryptoDataCall().dataUpdate(crypto, crypto)
            UltimateAverageIndicator().calculateUltimate(crypto)
            updatePositionBadgesFunction(crypto)
            
        }
        
        PositionCoherence().callPositionCoherence()
        
        updateLabelsDelayTimer()
        updateVotesLabelsDelayTimer()
        //voteLabel()
    
        toggleVoteButtonAvailability()
        
        updateReferenceVariables()
        
        updateWallet()
        
        updateForecastDelayTimer()
    }
    
    @objc func refreshLabels() {
        callUpdateLabels()
    }
    func refreshPrices() {
        DispatchQueue.main.async {
            self.updateUIs()
        }
    }
    @objc func refreshData(refreshControl: UIRefreshControl) {
        DispatchQueue.main.async {
            self.updateUIs()
            refreshControl.endRefreshing()
        }
    }
    
    func updateLabelsDelayTimer() {
        let myTimer = Timer(timeInterval: 0.8, target: self, selector: #selector(MainViewController.refreshLabels), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    func updateVotesLabelsDelayTimer() {
        let myTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(MainViewController.refreshVotesLabels), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    @objc func updateUIsDelayTimer() {
        let myTimer = Timer(timeInterval: 1.5, target: self, selector: #selector(self.updateUIs), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    func updateForecastDelayTimer() {
        let myTimer = Timer(timeInterval: 1.5, target: self, selector: #selector(MainViewController.forecastAlertAvailable), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func voteLabel() {
        votesTrend.setImage(UIImage(named: "Trend-Down"), for: UIControlState.normal)
        votesPosition.setImage(UIImage(named: "Round-Buy"), for: UIControlState.normal)
    }
    
    @objc func refreshVotesLabels() {
        
        if UserDefaults.standard.string(forKey: "votesTrend") != nil {
            let currentVotesTrend = UserDefaults.standard.string(forKey: "votesTrend")
            
            if currentVotesTrend == "Up" {
                votesTrend.setImage(UIImage(named: "Trend-Up"), for: UIControlState.normal)
            } else if currentVotesTrend == "Stable" {
                votesTrend.setImage(UIImage(named: "Trend-Stable"), for: UIControlState.normal)
            } else {
                votesTrend.setImage(UIImage(named: "Trend-Down"), for: UIControlState.normal)
            }
        }
        
        if UserDefaults.standard.string(forKey: "votesPosition") != nil {
            let currentVotesPosition = UserDefaults.standard.string(forKey: "votesPosition")
            
            if currentVotesPosition == "Sell" {
                votesPosition.setImage(UIImage(named: "Round-Sell"), for: UIControlState.normal)
            } else if currentVotesPosition == "Buy" {
                votesPosition.setImage(UIImage(named: "Round-Buy"), for: UIControlState.normal)
            } else {
                votesPosition.setImage(UIImage(named: "Round-Hold"), for: UIControlState.normal)
            }
        }
    }
    
    @objc func forecastAlertAvailable() {
        
        MarketViewController().remainingTimeBeforeNextForecast(caller: "MainVC")
        
        if MarketViewController.remainingSomething == false {
            if MainViewController.alertCount == 0 {
                self.forecastAlert(title: "It's time! 😊", message: "Check if you guessed the Bitcoin price right!")
                MainViewController.alertCount = 1
            }
        }
    }
    
    //------------------
    // Update UI Labels
    //------------------
    func updateLabels(_ crypto: String) {
        
        let mainViewPriceStringDict : [String : String] =
            
            ["bitcoin": MainViewController.bitcoinPriceString,
             "bitcoinCash": MainViewController.bitcoinCashPriceString,
             "ethereum": MainViewController.ethereumPriceString,
             "litecoin": MainViewController.litecoinPriceString,
             "ripple": MainViewController.ripplePriceString]
        
        let mainViewPercentStringDict : [String : String] =
            
            ["bitcoin": MainViewController.bitcoinPercentageChangeString,
             "bitcoinCash": MainViewController.bitcoinCashPercentageChangeString,
             "ethereum": MainViewController.ethereumPercentageChangeString,
             "litecoin": MainViewController.litecoinPercentageChangeString,
             "ripple": MainViewController.ripplePercentageChangeString]
        
        let dataLabelsDict : [String : UILabel] =
            
            ["bitcoin": bitcoinData,
             "bitcoinCash": bitcoinCashData,
             "ethereum": ethereumData,
             "litecoin": litecoinData,
             "ripple": rippleData]
        
        let differenceLabelsDict : [String : UILabel] =
            
            ["bitcoin": bitcoinDifference,
             "bitcoinCash": bitcoinCashDifference,
             "ethereum": ethereumDifference,
             "litecoin": litecoinDifference,
             "ripple": rippleDifference]
        
        let mainViewPSDict = mainViewPriceStringDict[crypto]
        guard var mainViewPriceString = mainViewPSDict else { return }
        
        let mainViewPercentDict = mainViewPercentStringDict[crypto]
        guard var mainViewPercentString = mainViewPercentDict else { return }
        
        let dataLDict = dataLabelsDict[crypto]
        guard let dataLabels = dataLDict else { return }
        
        let diffLabelsDict = differenceLabelsDict[crypto]
        guard let differenceLabel = diffLabelsDict else { return }
        
        guard let holdCurrency = CurrentDifferenceFunctions.holdDict[crypto] else { return }
        guard let buyOrSellState = CurrentDifferenceFunctions.buyOrSellStateDict[crypto] else { return }
        
        guard let differencePrice = CurrentDifferenceFunctions.differencePriceDict[crypto] else { return }
        guard let differencePercent = CurrentDifferenceFunctions.differencePercentDict[crypto] else { return }
        
        guard let priceStr = UpdateVariablesFunctions.pricesDic[crypto] else { return }
        guard let percentStr = UpdateVariablesFunctions.percentDic[crypto] else { return }
    
        DispatchQueue.main.async {
            
            // ---> Prices and percent labels
            //--------------------------------
            
            if priceStr != "" {
                mainViewPriceString = String(priceStr + ", ")
            } else {
                //self.updateUIs()
                mainViewPriceString = String("Pull to refresh")
                mainViewPercentString = String("")
            }
            if percentStr != "" {
                mainViewPercentString = percentStr
            } else {
                //self.updateUIs()
                mainViewPriceString = String("Pull to refresh")
                mainViewPercentString = String("")
            }
            
            if percentStr.contains("-") {
                let string = mainViewPriceString + mainViewPercentString
                let mainText = string
                let percentageText = mainViewPercentString
                let range = (mainText as NSString).range(of: percentageText)
                let attributedString = NSMutableAttributedString(string:mainText)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: range)
                dataLabels.attributedText = attributedString
            } else {
                let string = mainViewPriceString + mainViewPercentString
                let mainText = string
                let percentageText = mainViewPercentString
                let range = (mainText as NSString).range(of: percentageText)
                let attributedString = NSMutableAttributedString(string:mainText)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green, range: range)
                dataLabels.attributedText = attributedString
            }
            
            // ---> Difference analytics labels
            //----------------------------------
            
            if holdCurrency == true {
                if buyOrSellState == 1 {
                    if differencePrice != "" && differencePrice.contains("-") {
                        differenceLabel.text = "Since last BUY position: \(differencePrice) (\(differencePercent))"
                    } else if differencePrice != "" {
                        differenceLabel.text = "Since last BUY position: +\(differencePrice) (\(differencePercent))"
                    } else {
                        differenceLabel.text = "Analyzing data..."
                    }
                } else if buyOrSellState == 2 {
                    if differencePrice != "" && differencePrice.contains("-") {
                        differenceLabel.text = "Since last SELL position: \(differencePrice) (\(differencePercent))"
                    } else if differencePrice != "" {
                        differenceLabel.text = "Since last SELL position: +\(differencePrice) (\(differencePercent))"
                    } else {
                        differenceLabel.text = "Analyzing data..."
                    }
                } else if buyOrSellState == 0 {
                    differenceLabel.text = "No data to analyze yet"
                }
            } else if holdCurrency == false && buyOrSellState == 1 {
                differenceLabel.text = "BUY position ongoing"
            } else if holdCurrency == false && buyOrSellState == 2 {
                differenceLabel.text = "SELL position ongoing"
            } else if holdCurrency == false && buyOrSellState == 0 {
                differenceLabel.text = "Can't load the correct data"
            }
            
            //----------------------------------------------------
            if MainViewController.aggressiveSwitchState == true {
                self.bitcoinDifference.text = "No data analyzing possible"
                self.bitcoinCashDifference.text = "No data analyzing possible"
                self.ethereumDifference.text = "No data analyzing possible"
                self.litecoinDifference.text = "No data analyzing possible"
                self.rippleDifference.text = "No data analyzing possible"
            }
             
        }
    }
    
    // ---> Call Update UI Labels Function
    //-------------------------------------
    func callUpdateLabels() {
        
        for crypto in MainViewController.cryptoDic {
            updateLabels(crypto)
        }
    }
    
    //---------------------------
    // Update UI Badges Function
    //---------------------------
    func updatePositionBadgesFunction(_ crypto: String) {
        
        print("updatePositionBadgesFunction")
        
        let badgesDictionary : [String : UIButton] =
            
            ["bitcoin": bitcoinBadgeButton,
             "bitcoinCash": bitcoinCashBadgeButton,
             "ethereum": ethereumBadgeButton,
             "litecoin": litecoinBadgeButton,
             "ripple": rippleBadgeButton]
        
        let holdBadgesDictionary : [String : UIImageView] =
            
            ["bitcoin": bitcoinHoldAnimateBadge,
             "bitcoinCash": bitcoinCashHoldAnimatedBadge,
             "ethereum": ethereumHoldAnimatedBadge,
             "litecoin": litecoinHoldAnimatedBadge,
             "ripple": rippleHoldAnimatedBadge]
        
        let stopCellAnimationDict : [String : () -> Void] =
            
            ["bitcoin": MainViewController().stopCell1PreviousAnimation,
             "bitcoinCash": MainViewController().stopCell2PreviousAnimation,
             "ethereum": MainViewController().stopCell3PreviousAnimation,
             "litecoin": MainViewController().stopCell4PreviousAnimation,
             "ripple": MainViewController().stopCell5PreviousAnimation]
        
        
        let badgesDict = badgesDictionary[crypto]
        guard let badge = badgesDict else { return }
        
        let holdBadgesDict = holdBadgesDictionary[crypto]
        guard let holdBadge = holdBadgesDict else { return }

        let stopCellAnimDict = stopCellAnimationDict[crypto]
        guard let stopCellAnimationFunction = stopCellAnimDict else { return }
        
        guard let userDefaultsFirstBuyKey = MainViewController.firstBuyDict[crypto] else { return }
        guard let userDefaultsFirstSellKey = MainViewController.firstSellDict[crypto] else { return }
        
        guard let ultimateIndicator = UltimateAverageIndicator.ultimateAverageIndicatorDict[crypto] else { return }
        guard let rsi = CryptoRelativeStrengthIndex.rsiDict[crypto] else { return }
        guard let ichimoku = CryptoIchimoku.ichimokuDict[crypto] else { return }
        
        guard let currentPrice = CryptoInfo.cryptoPriceDic[crypto] else { return }
        guard let currentPercent = CryptoInfo.cryptoPercentDic[crypto] else { return }

        DispatchQueue.main.async {
            
            if MainViewController.aggressiveSwitchState == false {

                // ---> Buy Position
                //--------------------
                if ultimateIndicator < 1 && rsi < 32 && rsi > 1 && currentPercent < -3 && ichimoku <= 1 || currentPercent < -6.73 && rsi < 40 && rsi > 1 && ichimoku <= 1 || currentPercent < -8.38 {
                    
                    badge.setImage(UIImage(named: "Badge-buy"), for: UIControlState.normal)
                    holdBadge.image = UIImage(named: "")
                
                    MainViewController.buyPositionDict[crypto] = true
                    MainViewController.sellPositionDict[crypto] = false
                
                    UserDefaults.standard.set(currentPrice, forKey: "\(userDefaultsFirstBuyKey)")
                    MainViewController.firstBuyDict[crypto] = userDefaultsFirstBuyKey
                
                    CurrentDifferenceFunctions().savePosition(crypto, "buy")
                    
                    stopCellAnimationFunction()
                    self.buyAndSellAnimation(crypto)
                    
                    let currentDate = Date()
                    UserDefaults.standard.set(currentDate, forKey: "lastPositionDate")
                    
                } else if MainViewController.buyPositionDict[crypto] == true {
                    badge.setImage(UIImage(named: "Badge-buy"), for: UIControlState.normal)
                    holdBadge.image = UIImage(named: "")
                    
                    MainViewController.buyPositionDict[crypto] = true
                    MainViewController.sellPositionDict[crypto] = false
                    
                    UserDefaults.standard.set(currentPrice, forKey: "\(userDefaultsFirstBuyKey)")
                    MainViewController.firstBuyDict[crypto] = userDefaultsFirstBuyKey
                    
                    CurrentDifferenceFunctions().savePosition(crypto, "buy")
                    
                    stopCellAnimationFunction()
                    self.buyAndSellAnimation(crypto)
            
                // ---> Sell Position
                //--------------------
                } else if ultimateIndicator > 21.5 && rsi > 70 && ichimoku >= 4 && currentPercent > 8 {
                    
                    badge.setImage(UIImage(named: "Badge-sell"), for: UIControlState.normal)
                    holdBadge.image = UIImage(named: "")

                    MainViewController.sellPositionDict[crypto] = true
                    MainViewController.buyPositionDict[crypto] = false
                    
                    UserDefaults.standard.set(currentPrice, forKey: "\(userDefaultsFirstSellKey)")
                    MainViewController.firstSellDict[crypto] = userDefaultsFirstSellKey
                    
                    CurrentDifferenceFunctions().savePosition(crypto, "sell")
                    
                    stopCellAnimationFunction()
                    self.buyAndSellAnimation(crypto)
                    
                    let currentDate = Date()
                    UserDefaults.standard.set(currentDate, forKey: "lastPositionDate")
                    
                } else if MainViewController.sellPositionDict[crypto] == true {
                    badge.setImage(UIImage(named: "Badge-sell"), for: UIControlState.normal)
                    holdBadge.image = UIImage(named: "")

                    MainViewController.sellPositionDict[crypto] = true
                    MainViewController.buyPositionDict[crypto] = false
                    
                    UserDefaults.standard.set(currentPrice, forKey: "\(userDefaultsFirstSellKey)")
                    MainViewController.firstSellDict[crypto] = userDefaultsFirstSellKey
                    
                    CurrentDifferenceFunctions().savePosition(crypto, "sell")
                    
                    stopCellAnimationFunction()
                    self.buyAndSellAnimation(crypto)
                    
                // ---> Hold Position
                //--------------------
                } else {

                    badge.setImage(UIImage(named: "Hold-Button-Image"), for: UIControlState.normal)
                    holdBadge.image = UIImage(named: "Hold-Animate")
                    
                    CurrentDifferenceFunctions().triggerCalculations(crypto)
                    
                    ResetData().shouldResetData(crypto)
                    
                    stopCellAnimationFunction()
                    self.holdBadgesAnimation()
                }
            // ---> Aggressive Switch == true
            //--------------------------------
            } else { // to complete
                
                stopCellAnimationFunction()
                
                if ultimateIndicator < 2.5 && rsi < 42 && rsi > 1 && currentPercent < -1 || currentPercent < -5 {
                    badge.setImage(UIImage(named: "Badge-buy"), for: UIControlState.normal)
                    holdBadge.image = UIImage(named: "")
                    
                    //self.buyAndSellAnimation()
                    
                } else if ultimateIndicator > 18.0 && rsi > 56 && currentPercent > 1 || currentPercent > 7 {
                    badge.setImage(UIImage(named: "Badge-sell"), for: UIControlState.normal)
                    holdBadge.image = UIImage(named: "")
                    
                    //self.buyAndSellAnimation()
                    
                } else {
                    badge.setImage(UIImage(named: "Badge-hold"), for: UIControlState.normal)
                    holdBadge.image = UIImage(named: "")
                    
                    //self.holdBadgesAnimation()
                }
            }
        }
    }

    //----------------------------
    // Update reference variables
    //----------------------------
    func updateReferenceVariables() {
        guard let bitcoin = CryptoInfo.cryptoPriceDic["bitcoin"] else { return }
        MainViewController.bitcoinDoublePrice = bitcoin
        guard let bitcoinCash = CryptoInfo.cryptoPriceDic["bitcoinCash"] else { return }
        MainViewController.bitcoinCashDoublePrice = bitcoinCash
        guard let ethereum = CryptoInfo.cryptoPriceDic["ethereum"] else { return }
        MainViewController.ethereumDoublePrice = ethereum
        guard let litecoin = CryptoInfo.cryptoPriceDic["litecoin"] else { return }
        MainViewController.litecoinDoublePrice = litecoin
        guard let ripple = CryptoInfo.cryptoPriceDic["ripple"] else { return }
        MainViewController.rippleDoublePrice = ripple
    }
    
    //------------------
    // Wallet functions
    //------------------
    
    var walletTotal = 0.0
    
    func updateWallet() {
        updateWalletValue()
        updateWalletLabel()
    }
    func updateWalletValue() {
        
        var values : [Double] = []
        
        guard let items : [CryptosMO] = CDHandler.fetchObject() else { return }
        
        let codes = items.map { $0.code! }
        let amounts = items.map { $0.amount! }
        
        for (code, amount) in zip(codes, amounts){
            
            let convertedAmount = Double(amount)!
            
            let crypto = code
            print("crypto", crypto)
            CryptoDataCall().dataUpdate(crypto, crypto)
            guard let price = CryptoInfo.cryptoPriceDic[crypto] else { return }
            
            let calculation = price * convertedAmount
            values.append(calculation)
            
        }
        
        walletTotal = values.reduce(0.0, { $0 + Double($1) } )
        print("walletTotal", walletTotal)
    }
    func updateWalletLabel() {
    
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 4
        formatter.locale = Locale(identifier: "\(SettingsViewController.currencyCode)")
        walletValue.text = formatter.string(from: NSNumber(value: walletTotal))
    }
    
    //----------------
    // Badges actions
    //----------------
    
    // ---> BTC
    //----------
    @IBAction func bitcoinBadgeTapped(_ sender: UIButton) {
        
        Answers.logCustomEvent(withName: "User Clicked Bitcoin Badge", customAttributes: nil)
        
        if bitcoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || bitcoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.15) {
                self.bitcoinBadgeButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.bitcoinHoldAnimateBadge.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            UIView.animate(withDuration:0.15) {
                let imageView = self.bitcoinHoldAnimateBadge
                imageView?.alpha = 0.5
            }
        }
    }
    @IBAction func bitcoinBadgeToWallet(_ sender: Any) {
        
        if bitcoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || bitcoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.20) {
                self.bitcoinBadgeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.bitcoinBadgeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.bitcoinHoldAnimateBadge.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.bitcoinHoldAnimateBadge.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            UIView.animate(withDuration:0.20) {
                let imageView = self.bitcoinHoldAnimateBadge
                imageView?.alpha = 1
            }
        }

        /*
        if bitcoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else if bitcoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else {
            return
        }
         */
    }
    
    // ---> BCH
    //----------
    @IBAction func bitcoinCashBadgeTapped(_ sender: UIButton) {
        
        Answers.logCustomEvent(withName: "User Clicked BitcoinCash Badge", customAttributes: nil)
        
        if bitcoinCashBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || bitcoinCashBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.15) {
                self.bitcoinCashBadgeButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.bitcoinCashHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            UIView.animate(withDuration:0.15) {
                let imageView = self.bitcoinCashHoldAnimatedBadge
                imageView?.alpha = 0.5
            }
        }
    }
    @IBAction func bitcoinCashBadgeToWallet(_ sender: Any) {
        
        if bitcoinCashBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || bitcoinCashBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.20) {
                self.bitcoinCashBadgeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.bitcoinCashBadgeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.bitcoinCashHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.bitcoinCashHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            UIView.animate(withDuration:0.20) {
                let imageView = self.bitcoinCashHoldAnimatedBadge
                imageView?.alpha = 1
            }
        }
        /*
        if bitcoinCashBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else if bitcoinCashBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else {
            return
        }
         */
    }
    
    // ---> ETH
    //-----------
    @IBAction func ethereumBadgeTapped(_ sender: UIButton) {
        
        Answers.logCustomEvent(withName: "User Clicked Ethereum Badge", customAttributes: nil)
        
        if ethereumBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || ethereumBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.15) {
                self.ethereumBadgeButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.ethereumHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            UIView.animate(withDuration:0.15) {
                let imageView = self.ethereumHoldAnimatedBadge
                imageView?.alpha = 0.5
            }
        }
    }
    @IBAction func ethereumBadgeToWallet(_ sender: Any) {
        
        if ethereumBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || ethereumBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.20) {
                self.ethereumBadgeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.ethereumBadgeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.ethereumHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.ethereumHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            UIView.animate(withDuration:0.20) {
                let imageView = self.ethereumHoldAnimatedBadge
                imageView?.alpha = 1
            }
        }
        /*
        if ethereumBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else if ethereumBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else {
            return
        }
         */
    }
    
    // ---> LTC
    //-----------
    @IBAction func litecoinBadgeTapped(_ sender: UIButton) {
        
        Answers.logCustomEvent(withName: "User Clicked Litecoin Badge", customAttributes: nil)
        
        if litecoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || litecoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.15) {
                self.litecoinBadgeButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.litecoinHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            UIView.animate(withDuration:0.15) {
                let imageView = self.litecoinHoldAnimatedBadge
                imageView?.alpha = 0.5
            }
        }
    }
    @IBAction func litecoinBadgeToWallet(_ sender: Any) {
        
        if litecoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || litecoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.20) {
                self.litecoinBadgeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.litecoinBadgeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.litecoinHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.litecoinHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            UIView.animate(withDuration:0.20) {
                let imageView = self.litecoinHoldAnimatedBadge
                imageView?.alpha = 1
            }
        }
        /*
        if litecoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else if litecoinBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else {
            return
        }
    */
    }
    
    //---> XRP
    //---------
    @IBAction func rippleBadgeTapped(_ sender: UIButton) {
        
        Answers.logCustomEvent(withName: "User Clicked Ripple Badge", customAttributes: nil)
        
        if rippleBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || rippleBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.15) {
                self.rippleBadgeButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.rippleHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            UIView.animate(withDuration:0.15) {
                let imageView = self.rippleHoldAnimatedBadge
                imageView?.alpha = 0.5
            }
        }
    }
    @IBAction func rippleBadgeToWallet(_ sender: Any) {
        
        if rippleBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") || rippleBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            return
        } else {
            UIView.animate(withDuration: 0.20) {
                self.rippleBadgeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.rippleBadgeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.rippleHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.rippleHoldAnimatedBadge.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            UIView.animate(withDuration:0.20) {
                let imageView = self.rippleHoldAnimatedBadge
                imageView?.alpha = 1
            }
        }
        /*
        if rippleBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-sell") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else if rippleBadgeButton.image(for: UIControlState.normal) == UIImage(named: "Badge-buy") {
            let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController")
            self.navigationController?.pushViewController(walletViewController!, animated: true)
        } else {
            return
        }
         */
    }
    
    // --------> Vote Button special functions
    //--------------------------------------------
    func toggleVoteButtonAvailability() {
       
        let currentDate = Date()
        var lastVoteDate: Date?
        var timeSinceLastVote: TimeInterval?
        
        
        if UserDefaults.standard.object(forKey: "lastVoteDate") != nil {
            lastVoteDate = UserDefaults.standard.value(forKey: "lastVoteDate") as? Date
            
            timeSinceLastVote = (currentDate.timeIntervalSince(lastVoteDate!)) / 900
            MainViewController.lastVote = Double(timeSinceLastVote!)
            
            if MainViewController.lastVote < 1 {
                marketButton?.isEnabled = false
                MainViewController.voteButtonEnabled = false
                marketButton.setImage(UIImage(named: "Trend-Logo-Disabled"), for: UIControlState.normal)
                animateVoteButton()
                
            } else {
                marketButton?.isEnabled = true
                MainViewController.voteButtonEnabled = true
                marketButton.setImage(UIImage(named: "Trend-Logo"), for: UIControlState.normal)
                animateVoteButton()
            }
        } else {
            marketButton?.isEnabled = true
            MainViewController.voteButtonEnabled = true
            marketButton.setImage(UIImage(named: "Trend-Logo"), for: UIControlState.normal)
            animateVoteButton()
        }
    }
    
    func animateVoteButton() {
        if marketButton?.image(for: UIControlState.normal) == UIImage(named: "Trend-Logo") {
            UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
                self.marketButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.marketButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: nil)
        
        } else {
            marketButton.layer.removeAllAnimations()
        }
    }
   

    //-------------------------
    // The Round Buttons functions
    //-------------------------
    @IBAction func communityButtonTapped(_ sender: Any) {
        let communityViewController = self.storyboard?.instantiateViewController(withIdentifier: "communityViewController")
        self.present(communityViewController!, animated: true)
        Answers.logCustomEvent(withName: "User -> Community", customAttributes: nil)
    }
    @IBAction func marketButtonTapped(_ sender: Any) {
        let marketViewController = self.storyboard?.instantiateViewController(withIdentifier: "marketViewController")
        self.present(marketViewController!, animated: true)
        Answers.logCustomEvent(withName: "User -> Votes", customAttributes: nil)
    }
    @IBAction func newsButtonTapped(_ sender: Any) {
        let newsViewController = self.storyboard?.instantiateViewController(withIdentifier: "newsViewController")
        self.present(newsViewController!, animated: true)
        Answers.logCustomEvent(withName: "User -> News", customAttributes: nil)
    }
    @IBAction func walletButtonTapped(_ sender: Any) {
        let walletViewController = self.storyboard?.instantiateViewController(withIdentifier: "walletTableViewController") as? WalletTableViewController
        self.present(walletViewController!, animated: true)
        Answers.logCustomEvent(withName: "User -> Wallet", customAttributes: nil)
    }
    @IBAction func accountButtonTapped(_ sender: Any) {
        let accountViewController = self.storyboard?.instantiateViewController(withIdentifier: "accountViewController")
        self.present(accountViewController!, animated: true)
        Answers.logCustomEvent(withName: "User -> Account", customAttributes: nil)
    }
    @IBAction func settingsButtonTapped(_ sender: Any) {
        let settingsViewController = self.storyboard?.instantiateViewController(withIdentifier: "settingsViewController")
        self.present(settingsViewController!, animated: true)
        Answers.logCustomEvent(withName: "User -> Settings", customAttributes: nil)
    }
   
    // ---> Alert
    //--------------
    @objc func voteAlert() {
        voteInfoAlert(title: "+5 CGO Tokens! ♥️", message: "Thank you for your vote, you're an important member of the community! Come back in 15 minutes to give your opinion again and earn more tokens.")
    }
    func voteInfoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            if UserDefaults.standard.bool(forKey: "userRated") != true {
                self.askForRating()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func forecastAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Check Now", style: UIAlertActionStyle.default, handler: { (action) in
            let marketViewController = self.storyboard?.instantiateViewController(withIdentifier: "marketViewController")
            self.present(marketViewController!, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // ---> App Review
    //-----------------
    func rateApp() {
        if #available( iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            
            if UserDefaults.standard.object(forKey: "cgoTokens") != nil {
                let lastCGOTokensAmount = UserDefaults.standard.double(forKey: "cgoTokens")
                MarketViewController.cgoTokens = lastCGOTokensAmount + 50
                UserDefaults.standard.set(MarketViewController.cgoTokens, forKey: "cgoTokens")
            } else {
                MarketViewController.cgoTokens = 50
                UserDefaults.standard.set(MarketViewController.cgoTokens, forKey: "cgoTokens")
            }
        }
    }
    func askForRating() {
        reviewAlert(title: "Bonus!? 🤑", message: "Rate the app 4 or 5 stars and get your +50 CGO Tokens bonus! It takes less than 5 seconds without leaving the app!")
    }
    func reviewAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.rateApp()
            UserDefaults.standard.set(true, forKey: "userRated")
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

extension UIButton {
    func hasImage(named imageName: String, for state: UIControlState) -> Bool {
        guard let buttonImage = image(for: state), let namedImage = UIImage(named: imageName) else {
            return false
        }
        
        return UIImagePNGRepresentation(buttonImage) == UIImagePNGRepresentation(namedImage)
    }
}

extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}

extension MainViewController {
    
    static var btcPercent : Double = 0
    static var bchPercent : Double = 0
    static var ethPercent : Double = 0
    static var ltcPercent : Double = 0
    static var xrpPercent : Double = 0
    static var adaPercent : Double = 0
    static var neoPercent : Double = 0
    static var xlmPercent : Double = 0
    static var xmrPercent : Double = 0
    static var iotaPercent : Double = 0
    static var dashPercent : Double = 0
    static var xemPercent : Double = 0
    static var etcPercent : Double = 0
    static var qtumPercent : Double = 0
    static var xrbPercent : Double = 0
    static var lskPercent : Double = 0
    static var btgPercent : Double = 0
    static var zecPercent : Double = 0
    static var steemPercent : Double = 0
    static var stratPercent : Double = 0
    static var xvgPercent : Double = 0
    static var wavesPercent : Double = 0
    static var scPercent : Double = 0
    static var dogePercent : Double = 0
    static var slsPercent : Double = 0
    static var nxsPercent : Double = 0
    static var zclPercent : Double = 0
    static var hsrPercent : Double = 0
    static var btsPercent : Double = 0
    static var dcrPercent : Double = 0
    static var omgPercent : Double = 0
    static var eosPercent : Double = 0
    static var trxPercent : Double = 0
    static var repPercent : Double = 0
    
    
    static var bitcoinDoublePrice : Double = 0
    static var bitcoinCashDoublePrice : Double = 0
    static var ethereumDoublePrice : Double = 0
    static var litecoinDoublePrice : Double = 0
    static var rippleDoublePrice : Double = 0
    static var cardanoDoublePrice : Double = 0
    static var neoDoublePrice : Double = 0
    static var stellarDoublePrice : Double = 0
    static var moneroDoublePrice : Double = 0
    static var iotaDoublePrice : Double = 0
    static var dashDoublePrice : Double = 0
    static var nemDoublePrice : Double = 0
    static var ethereumClassicDoublePrice : Double = 0
    static var qtumDoublePrice : Double = 0
    static var nanoDoublePrice : Double = 0
    static var liskDoublePrice : Double = 0
    static var bitcoinGoldDoublePrice : Double = 0
    static var zcashDoublePrice : Double = 0
    static var steemDoublePrice : Double = 0
    static var stratisDoublePrice : Double = 0
    static var vergeDoublePrice : Double = 0
    static var wavesDoublePrice : Double = 0
    static var siacoinDoublePrice : Double = 0
    static var dogecoinDoublePrice : Double = 0
    static var salusDoublePrice : Double = 0
    static var nexusDoublePrice : Double = 0
    static var zclassicDoublePrice : Double = 0
    static var hshareDoublePrice : Double = 0
    static var bitsharesDoublePrice : Double = 0
    static var decredDoublePrice : Double = 0
    static var omisegoDoublePrice : Double = 0
    static var eosDoublePrice : Double = 0
    static var tronDoublePrice : Double = 0
    static var augurDoublePrice : Double = 0
}
