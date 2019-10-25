//
//  UltimateAverageIndicator.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 30/12/2017.
//  Copyright © 2017 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit

class UltimateAverageIndicator: MainViewController {
    
    static var ultimateBitcoinIndicator : Double = 0
    static var ultimateBitcoinCashIndicator : Double = 0
    static var ultimateEthereumIndicator : Double = 0
    static var ultimateLitecoinIndicator : Double = 0
    static var ultimateRippleIndicator : Double = 0
    
    static var ultimateAverageIndicatorDict = ["bitcoin" : UltimateAverageIndicator.ultimateBitcoinIndicator,
                                               "bitcoinCash" : UltimateAverageIndicator.ultimateBitcoinCashIndicator,
                                               "ethereum" : UltimateAverageIndicator.ultimateEthereumIndicator,
                                               "litecoin" : UltimateAverageIndicator.ultimateLitecoinIndicator,
                                               "ripple" : UltimateAverageIndicator.ultimateRippleIndicator]
    
    func calculateUltimate(_ crypto: String) {
        
        var ultimateIndicator = 0.0
        
        guard let rsi = CryptoRelativeStrengthIndex.rsiDict[crypto] else { return }
        guard let percent = CryptoInfo.cryptoPercentDic[crypto] else { return }
        
        if percent > 0 {
            ultimateIndicator = rsi + (4.5 * percent ) / 5.5
            UltimateAverageIndicator.ultimateAverageIndicatorDict[crypto] = ultimateIndicator
            
        } else {
            ultimateIndicator = rsi + (5.5 * percent ) / 6
            UltimateAverageIndicator.ultimateAverageIndicatorDict[crypto] = ultimateIndicator
        }
    }

}
