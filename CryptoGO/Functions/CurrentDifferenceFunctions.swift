//
//  CurrentDifferenceFunctions.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 29/01/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation

class CurrentDifferenceFunctions : MainViewController {
    
    static var buyOrSellBitcoinState : Int = 0
    static var buyOrSellBitcoinCashState : Int = 0
    static var buyOrSellEthereumState : Int = 0
    static var buyOrSellLitecoinState : Int = 0
    static var buyOrSellRippleState : Int = 0
    
    static var savedBitcoinPrice : Double = 0
    static var savedBitcoinCashPrice : Double = 0
    static var savedEthereumPrice : Double = 0
    static var savedLitecoinPrice : Double = 0
    static var savedRipplePrice : Double = 0
    
    static var differenceBitcoinDouble : Double = 0
    static var differenceBitcoinCashDouble : Double = 0
    static var differenceEthereumDouble : Double = 0
    static var differenceLitecoinDouble : Double = 0
    static var differenceRippleDouble : Double = 0
    
    static var differenceBitcoinString : String = ""
    static var differenceBitcoinCashString : String = ""
    static var differenceEthereumString : String = ""
    static var differenceLitecoinString : String = ""
    static var differenceRippleString : String = ""
    
    static var differencePercentBitcoinString : String = ""
    static var differencePercentBitcoinCashString : String = ""
    static var differencePercentEthereumString : String = ""
    static var differencePercentLitecoinString : String = ""
    static var differencePercentRippleString : String = ""
    
    static var holdBitcoin : Bool = false
    static var holdBitcoinCash : Bool = false
    static var holdEthereum : Bool = false
    static var holdLitecoin : Bool = false
    static var holdRipple : Bool = false
    
    static var resetBitcoin : Bool = false
    static var resetBitcoinCash : Bool = false
    static var resetEthereum : Bool = false
    static var resetLitecoin : Bool = false
    static var resetRipple : Bool = false
    
    static var differenceDoublePriceDict : [String : Double] =
        
        ["bitcoin": CurrentDifferenceFunctions.differenceBitcoinDouble,
         "bitcoinCash": CurrentDifferenceFunctions.differenceBitcoinCashDouble,
         "ethereum": CurrentDifferenceFunctions.differenceEthereumDouble,
         "litecoin": CurrentDifferenceFunctions.differenceLitecoinDouble,
         "ripple": CurrentDifferenceFunctions.differenceRippleDouble]
    
    static var differencePriceDict : [String : String] =
        
        ["bitcoin": CurrentDifferenceFunctions.differenceBitcoinString,
         "bitcoinCash": CurrentDifferenceFunctions.differenceBitcoinCashString,
         "ethereum": CurrentDifferenceFunctions.differenceEthereumString,
         "litecoin": CurrentDifferenceFunctions.differenceLitecoinString,
         "ripple": CurrentDifferenceFunctions.differenceRippleString]
    
    static var differencePercentDict : [String : String] =
        
        ["bitcoin": CurrentDifferenceFunctions.differencePercentBitcoinString,
         "bitcoinCash": CurrentDifferenceFunctions.differencePercentBitcoinCashString,
         "ethereum": CurrentDifferenceFunctions.differencePercentEthereumString,
         "litecoin": CurrentDifferenceFunctions.differencePercentLitecoinString,
         "ripple": CurrentDifferenceFunctions.differencePercentRippleString]
    
    static var buyOrSellStateDict : [String : Int] =
        
        ["bitcoin" : CurrentDifferenceFunctions.buyOrSellBitcoinState,
         "bitcoinCash" : CurrentDifferenceFunctions.buyOrSellBitcoinCashState,
         "ethereum" : CurrentDifferenceFunctions.buyOrSellEthereumState,
         "litecoin" : CurrentDifferenceFunctions.buyOrSellLitecoinState,
         "ripple" : CurrentDifferenceFunctions.buyOrSellRippleState]
    
    static var savedPriceDict : [String : Double] =
        
        ["bitcoin" : CurrentDifferenceFunctions.savedBitcoinPrice,
         "bitcoinCash" : CurrentDifferenceFunctions.savedBitcoinCashPrice,
         "ethereum" : CurrentDifferenceFunctions.savedEthereumPrice,
         "litecoin" : CurrentDifferenceFunctions.savedLitecoinPrice,
         "ripple" : CurrentDifferenceFunctions.savedRipplePrice]
    
    static var holdDict : [String : Bool] =
        
        ["bitcoin" : CurrentDifferenceFunctions.holdBitcoin,
         "bitcoinCash" : CurrentDifferenceFunctions.holdBitcoinCash,
         "ethereum" : CurrentDifferenceFunctions.holdEthereum,
         "litecoin" : CurrentDifferenceFunctions.holdLitecoin,
         "ripple" : CurrentDifferenceFunctions.holdRipple]
    
    static var resetDict : [String : Bool] =
        
        ["bitcoin" : CurrentDifferenceFunctions.resetBitcoin,
         "bitcoinCash" : CurrentDifferenceFunctions.resetBitcoinCash,
         "ethereum" : CurrentDifferenceFunctions.resetEthereum,
         "litecoin" : CurrentDifferenceFunctions.resetLitecoin,
         "ripple" : CurrentDifferenceFunctions.resetRipple]
    
    func calculateDifference(_ crypto: String) {
        
        guard let currentPrice = CryptoInfo.cryptoPriceDic[crypto] else { return }
        
        if let savedBuyOrSellState = UserDefaults.standard.integer(forKey: "buyOrSell\(crypto)State-\(SettingsViewController.currencyCode)") as Int? {
            CurrentDifferenceFunctions.buyOrSellStateDict[crypto] = savedBuyOrSellState
            
            if CurrentDifferenceFunctions.buyOrSellStateDict[crypto] == 1 {
                if let savedBuyPrice = UserDefaults.standard.double(forKey: "saved\(crypto)BuyPrice-\(SettingsViewController.currencyCode)") as Double? {
                    CurrentDifferenceFunctions.savedPriceDict[crypto] = savedBuyPrice
                }
            } else if CurrentDifferenceFunctions.buyOrSellStateDict[crypto] == 2 {
                if let savedSellPrice = UserDefaults.standard.double(forKey: "saved\(crypto)SellPrice-\(SettingsViewController.currencyCode)") as Double? {
                    CurrentDifferenceFunctions.savedPriceDict[crypto] = savedSellPrice
                }
            }
        } else {
            CurrentDifferenceFunctions.buyOrSellStateDict[crypto] = 0
        }
        let difference = currentPrice - CurrentDifferenceFunctions.savedPriceDict[crypto]!
        let differencePercent = (difference / currentPrice) * 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "\(SettingsViewController.currencyCode)")
        CurrentDifferenceFunctions.differenceDoublePriceDict[crypto] = difference
        CurrentDifferenceFunctions.differencePriceDict[crypto] =  formatter.string(from: NSNumber(value: difference))!
        CurrentDifferenceFunctions.differencePercentDict[crypto] = String(format: "%.2f%%", differencePercent)
    }
    
    func savePosition(_ crypto: String, _ position: String) {
        guard let currentPrice = CryptoInfo.cryptoPriceDic[crypto] else { return }
        resetBuyOrSellState(crypto)
        CurrentDifferenceFunctions.holdDict[crypto] = false
        
        if position == "buy" {
            CurrentDifferenceFunctions.buyOrSellStateDict[crypto] = 1
            UserDefaults.standard.set(CurrentDifferenceFunctions.buyOrSellStateDict[crypto], forKey: "buyOrSell\(crypto)State-\(SettingsViewController.currencyCode)")
            UserDefaults.standard.set(currentPrice, forKey: "saved\(crypto)BuyPrice-\(SettingsViewController.currencyCode)")
        }
        if position == "sell" {
            CurrentDifferenceFunctions.buyOrSellStateDict[crypto] = 2
            UserDefaults.standard.set(CurrentDifferenceFunctions.buyOrSellStateDict[crypto], forKey: "buyOrSell\(crypto)State-\(SettingsViewController.currencyCode)")
            UserDefaults.standard.set(currentPrice, forKey: "saved\(crypto)SellPrice-\(SettingsViewController.currencyCode)")
        }
    }

    func triggerCalculations(_ crypto: String) {
        CurrentDifferenceFunctions.holdDict[crypto] = true
        calculateDifference(crypto)
    }
    
    //Reset BuyOrSell State before new position
    //------------------------------------------
    func resetBuyOrSellState(_ crypto: String) {
        guard let reset = CurrentDifferenceFunctions.resetDict[crypto] else { return }
        print("* reset \(crypto) =", reset)
        if reset == false {
            CurrentDifferenceFunctions.buyOrSellStateDict[crypto] = 0
            UserDefaults.standard.set(CurrentDifferenceFunctions.buyOrSellStateDict[crypto], forKey: "buyOrSell\(crypto)State-en_US")
            UserDefaults.standard.set(CurrentDifferenceFunctions.buyOrSellStateDict[crypto], forKey: "buyOrSell\(crypto)State-fr_FR")
            UserDefaults.standard.set(CurrentDifferenceFunctions.buyOrSellStateDict[crypto], forKey: "buyOrSell\(crypto)State-en_GB")
            UserDefaults.standard.set(CurrentDifferenceFunctions.buyOrSellStateDict[crypto], forKey: "buyOrSell\(crypto)State-zh-Hans-CN")
            UserDefaults.standard.set(CurrentDifferenceFunctions.buyOrSellStateDict[crypto], forKey: "buyOrSell\(crypto)State-ru_RU")
            CurrentDifferenceFunctions.resetDict[crypto] = true
        }
    }
}
