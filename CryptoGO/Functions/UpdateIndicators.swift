//
//  UpdateRSI.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 25/01/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation

class UpdateIndicators {
    
    var allowRefresh = true
    
    func refreshIndicatorsData() {
        
        let currentDate = Date()
        var lastDataRefresh: Date?
        var timeSinceLastRefresh: TimeInterval?
        
        if UserDefaults.standard.object(forKey: "lastDataRefresh") != nil {
            lastDataRefresh = UserDefaults.standard.value(forKey: "lastDataRefresh") as? Date
            
            timeSinceLastRefresh = (currentDate.timeIntervalSince(lastDataRefresh!)) / 60
            let doubleLastRefresh = Double(timeSinceLastRefresh!)
            
            if doubleLastRefresh < 1 {
            
                allowRefresh = false
                
            } else {
               allowRefresh = true
            }
        } else {
            allowRefresh = true
        }
        
        updateIndicators()
        
    }
    
    func updateIndicators() {
        
        if allowRefresh == true {
            
            let currentDate = Date()
            UserDefaults.standard.set(currentDate, forKey: "lastDataRefresh")
            
            for crypto in MainViewController.cryptoDic {
                
                fetchCryptoData(crypto: crypto) { items, error in
                    guard let items = items,
                        error == nil else {
                            print(error ?? "Unknown error")
                            return
                    }
                    let rsi = CryptoRelativeStrengthIndex()
                    rsi.items = items
                    rsi.calculateRSI(crypto: crypto)
                    let ichimoku = CryptoIchimoku()
                    ichimoku.items = items
                    ichimoku.calculateIchimoku(crypto: crypto)
                }
            }
        }
    }
}

