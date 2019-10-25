//
//  ResetData.swift
//  CryptoGO
//
//  Created by Domingo Delmas on 11/06/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation

class ResetData : MainViewController {
    
    func shouldResetData(_ crypto: String) {
    
        guard let price = CurrentDifferenceFunctions.differenceDoublePriceDict[crypto] else { return }
        guard let buyOrSellState = CurrentDifferenceFunctions.buyOrSellStateDict[crypto] else { return }
        
        print("RESET DATA Price :", price)
        print("RESET DATA Position :", buyOrSellState)
        
        if price < 0 && buyOrSellState == 1 {
            resetDataAfter2Days(crypto)
        }
    }
    
    func resetDataAfter2Days(_ crypto: String) {
        
        let currentDate = Date()
        var lastDataRefresh: Date?
        var timeSinceLastRefresh: TimeInterval?
        
        if UserDefaults.standard.object(forKey: "lastPositionDate") != nil {
            lastDataRefresh = UserDefaults.standard.value(forKey: "lastPositionDate") as? Date
            
            let eTime = (currentDate.timeIntervalSince(lastDataRefresh!))
            MarketViewController.elapsedTime = Double(eTime)
            
            timeSinceLastRefresh = (currentDate.timeIntervalSince(lastDataRefresh!)) / 172800 // 2 jours
            let doubleLastRefresh = Double(timeSinceLastRefresh!)
            
            if doubleLastRefresh < 1 {
                print("not 2 days yet")
            } else {
                CurrentDifferenceFunctions().resetBuyOrSellState(crypto)
            }
        } else {
            CurrentDifferenceFunctions().resetBuyOrSellState(crypto)
        }
    }
    
}

