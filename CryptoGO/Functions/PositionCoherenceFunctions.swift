//
//  PositionCoherenceFunctions.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 30/01/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit

class PositionCoherence : MainViewController {
    
    static var lastBTCPrice : Double = 0.0
    static var lastBCHPrice : Double = 0.0
    static var lastETHPrice : Double = 0.0
    static var lastLTCPrice : Double = 0.0
    static var lastXRPPrice : Double = 0.0
    
    static var lastBuyPrice : [String : String] =
        
        ["bitcoin": "lastBTCBuyPrice-\(SettingsViewController.currencyCode)",
         "bitcoinCash": "lastBCHBuyPrice-\(SettingsViewController.currencyCode)",
         "ethereum": "lastETHBuyPrice-\(SettingsViewController.currencyCode)",
         "litecoin": "lastLTCBuyPrice-\(SettingsViewController.currencyCode)",
         "ripple": "lastXRPBuyPrice-\(SettingsViewController.currencyCode)"]
    
    static var lastSellPrice : [String : String] =
        
        ["bitcoin": "lastBTCSellPrice-\(SettingsViewController.currencyCode)",
         "bitcoinCash": "lastBCHSellPrice-\(SettingsViewController.currencyCode)",
         "ethereum": "lastETHSellPrice-\(SettingsViewController.currencyCode)",
         "litecoin": "lastLTCSellPrice-\(SettingsViewController.currencyCode)",
         "ripple": "lastXRPSellPrice-\(SettingsViewController.currencyCode)"]
    
    var currentPricesDic : [String : Double] =
        
        ["bitcoin": MainViewController.bitcoinDoublePrice,
         "bitcoinCash": MainViewController.bitcoinCashDoublePrice,
         "ethereum": MainViewController.ethereumDoublePrice,
         "litecoin": MainViewController.litecoinDoublePrice,
         "ripple": MainViewController.rippleDoublePrice]
    
    static var savedPricesDic : [String : Double] =
    
        ["bitcoin": PositionCoherence.lastBTCPrice,
         "bitcoinCash": PositionCoherence.lastBCHPrice,
         "ethereum": PositionCoherence.lastETHPrice,
         "litecoin": PositionCoherence.lastLTCPrice,
         "ripple": PositionCoherence.lastXRPPrice]

    
    func positionCoherence(_ crypto: String) {
        
        let currentP = currentPricesDic[crypto]
        guard let currentPrice = currentP else { return }
        
        guard var currentBuyPosition = MainViewController.buyPositionDict[crypto] else { return }
        guard var currentSellPosition = MainViewController.sellPositionDict[crypto] else { return }
        
        guard let firstBuyKey = MainViewController.firstBuyDict[crypto] else { return }
        guard let firstSellKey = MainViewController.firstSellDict[crypto] else { return }
        
        guard var savedPrice = PositionCoherence.savedPricesDic[crypto] else { return }
        
        guard let lastBuyKey = PositionCoherence.lastBuyPrice[crypto] else { return }
        guard let lastSellKey = PositionCoherence.lastSellPrice[crypto] else { return }
        
        if currentBuyPosition == true { // ---> buy
            
            if let lastPrice = UserDefaults.standard.double(forKey: lastBuyKey) as Double? {
                savedPrice = lastPrice
                PositionCoherence.savedPricesDic[crypto] = savedPrice
                
                if savedPrice == 0.0 {
                    if let lastPrice = UserDefaults.standard.double(forKey: firstBuyKey) as Double? {
                        savedPrice = lastPrice
                        PositionCoherence.savedPricesDic[crypto] = savedPrice
                    }
                }
            }
            if currentPrice > savedPrice {
                currentBuyPosition = false
                MainViewController.buyPositionDict[crypto] = currentBuyPosition
                
                UserDefaults.standard.set(nil, forKey: lastSellKey)
                PositionCoherence.lastSellPrice[crypto] = lastSellKey
                
            } else { UserDefaults.standard.set(currentPrice, forKey: lastBuyKey)
                     PositionCoherence.lastBuyPrice[crypto] = lastBuyKey
            }
        }
        
        if currentSellPosition == true { // ---> sell
            
            if let lastPrice = UserDefaults.standard.double(forKey: lastSellKey) as Double? {
                savedPrice = lastPrice
                PositionCoherence.savedPricesDic[crypto] = savedPrice
                
                if savedPrice == 0.0 {
                    if let lastPrice = UserDefaults.standard.double(forKey: firstSellKey) as Double? {
                        savedPrice = lastPrice
                        PositionCoherence.savedPricesDic[crypto] = savedPrice
                    }
                }
            }
            if currentPrice < savedPrice {
                currentSellPosition = false
                MainViewController.sellPositionDict[crypto] = currentSellPosition
                
                UserDefaults.standard.set(nil, forKey: lastBuyKey)
                PositionCoherence.lastBuyPrice[crypto] = lastBuyKey
                
            } else { UserDefaults.standard.set(currentPrice, forKey: lastSellKey)
                     PositionCoherence.lastSellPrice[crypto] = lastSellKey
            }
        }
    }
    
    //------------------------------------
    
    func callPositionCoherence() {
        
        for crypto in MainViewController.cryptoDic {
            
            guard let currentBuyPosition = MainViewController.buyPositionDict[crypto] else { return }
            guard let currentSellPosition = MainViewController.sellPositionDict[crypto] else { return }
            
            if currentBuyPosition == true {
                positionCoherence(crypto)
            } else if currentSellPosition == true {
                positionCoherence(crypto)
            }
        }
    }
}
