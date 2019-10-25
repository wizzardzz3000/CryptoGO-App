//
//  BitcoinIchimoku.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 03/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit

enum FetchError: Error {
    case urlError
    case unknownNetworkError
}

struct CryptoData : Decodable {
    let value1, value2, close, high, low, value6 : Double
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        value1 = try container.decode(Double.self)
        value2 = try container.decode(Double.self)
        close = try container.decode(Double.self)
        high = try container.decode(Double.self)
        low = try container.decode(Double.self)
        value6 = try container.decode(Double.self)
    }
}

func fetchCryptoData(crypto: String, completion: @escaping ([CryptoData]?, Error?) -> Void) {
    
    var codeDict = ["bitcoin" : "BTC",
                    "bitcoinCash" : "BCH",
                    "ethereum" : "ETH",
                    "litecoin" : "LTC",
                    "ripple" : "XRP"]
    
    let codeD = codeDict[crypto]
    guard let code = codeD else { return }
    
    guard let url = URL(string: "https://api.bitfinex.com/v2/candles/trade:30m:t\(code)USD/hist") else { return }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            completion(nil, error ?? FetchError.unknownNetworkError)
            return
        }
        do {
            let crypto = try JSONDecoder().decode([CryptoData].self, from: data); completion(crypto, nil)
        } catch let parseError {
            completion(nil, parseError)
        }
    }
    task.resume()
}

class CryptoRelativeStrengthIndex : NSObject {
    
    var items : [CryptoData] = []
    
    static var bitcoinRSI : Double = 0
    static var bitcoinCashRSI : Double = 0
    static var ethereumRSI : Double = 0
    static var litecoinRSI : Double = 0
    static var rippleRSI : Double = 0
    
    static var rsiDict = ["bitcoin" : CryptoRelativeStrengthIndex.bitcoinRSI,
                          "bitcoinCash" : CryptoRelativeStrengthIndex.bitcoinCashRSI,
                          "ethereum" : CryptoRelativeStrengthIndex.ethereumRSI,
                          "litecoin" : CryptoRelativeStrengthIndex.litecoinRSI,
                          "ripple" : CryptoRelativeStrengthIndex.rippleRSI]
    
    func calculateRSI(crypto: String)
    {
        
        let period = 14
        
        // Upward Movements and Downward Movements
        var upwardMovements : [Double] = []
        var downwardMovements : [Double] = []
        
        for idx in 0..<15 {
            let diff = items[idx + 1].close - items[idx].close
            upwardMovements.append(max(diff, 0))
            downwardMovements.append(max(-diff, 0))
        }
        // Average Upward Movements and Average Downward Movements
        let averageUpwardMovement1 = upwardMovements[0..<period].reduce(0, +) / Double(period)
        let averageDownwardMovement1 = downwardMovements[0..<period].reduce(0, +) / Double(period)
        
        let averageUpwardMovement2 = (averageUpwardMovement1 * Double(period - 1) + upwardMovements[period]) / Double(period)
        let averageDownwardMovement2 = (averageDownwardMovement1 * Double(period - 1) + downwardMovements[period]) / Double(period)
        
        // Relative Strength
        let relativeStrength1 = averageUpwardMovement1 / averageDownwardMovement1
        let relativeStrength2 = averageUpwardMovement2 / averageDownwardMovement2
        
        // Relative Strength Index
        let rSI1 = 100 - (100 / (relativeStrength1 + 1))
        let rSI2 = 100 - (100 / (relativeStrength2 + 1))
        
        // Relative Strength Index Average
        let relativeStrengthAverage = (rSI1 + rSI2) / 2
        
        CryptoRelativeStrengthIndex.rsiDict[crypto] = relativeStrengthAverage

    }
}

class CryptoIchimoku {
    
    var items : [CryptoData] = []
    
    static var bitcoinIchimoku : Double = 0
    static var bitcoinCashIchimoku : Double = 0
    static var ethereumIchimoku : Double = 0
    static var litecoinIchimoku : Double = 0
    static var rippleIchimoku : Double = 0
    
    static var ichimokuDict = ["bitcoin": CryptoIchimoku.bitcoinIchimoku,
                               "bitcoinCash": CryptoIchimoku.bitcoinCashIchimoku,
                               "ethereum": CryptoIchimoku.ethereumIchimoku,
                               "litecoin": CryptoIchimoku.litecoinIchimoku,
                               "ripple": CryptoIchimoku.rippleIchimoku]
    
    func calculateIchimoku(crypto: String) {

            var conversionHighs : Double = 0
            var conversionLows : Double = 0
            var conversionHighsArray : [Double] = []
            var conversionLowsArray : [Double] = []
            var conversionLine : Double = 0
            
            var baseHighs : Double = 0
            var baseLows : Double = 0
            var baseHighsArray : [Double] = []
            var baseLowsArray : [Double] = []
            var baseLine : Double = 0
            
            var spanA : Double = 0
            
            var spanBHighs : Double = 0
            var spanBLows : Double = 0
            var spanBHighsArray : [Double] = []
            var spanBLowsArray : [Double] = []
            var spanB : Double = 0
            
            var oldPrice26 : Double = 0
            var currentPrice : Double = 0
            var laggingSpan : Double = 0
            
            // ---> Conversion Line (present)
            //---------------------
            for idx in 0..<10 {
                conversionHighs = items[idx].high
                conversionLows = items[idx].low
                conversionHighsArray.append(max(conversionHighs, 0))
                conversionLowsArray.append(max(conversionLows, 0))
                let highest = conversionHighsArray.max()
                let lowest = conversionLowsArray.min()
                guard let high = highest else { return }
                guard let low = lowest else { return }
                conversionLine = (high + low) / 2
            }
            
            // ---> Base Line
            //----------------
            for idx in 0..<27 {
                baseHighs = items[idx].high
                baseLows = items[idx].low
                baseHighsArray.append(max(baseHighs, 0))
                baseLowsArray.append(max(baseLows, 0))
                let highest = baseHighsArray.max()
                let lowest = baseLowsArray.min()
                guard let high = highest else { return }
                guard let low = lowest else { return }
                baseLine = (high + low) / 2
            }
            
            // ---> Span A
            //-------------
            spanA = (conversionLine + baseLine) / 2
            
            // ---> Span B
            //-------------
            for idx in 0..<53 {
                spanBHighs = items[idx].high
                spanBLows = items[idx].low
                spanBHighsArray.append(max(spanBHighs, 0))
                spanBLowsArray.append(max(spanBLows, 0))
                let highest = spanBHighsArray.max()
                let lowest = spanBLowsArray.min()
                guard let high = highest else { return }
                guard let low = lowest else { return }
                spanB = (high + low) / 2
            }
            
            // ---> 26 periods old price
            //-------------------
            oldPrice26 = items[26].close
            
            // ---> Current Price
            //--------------------
            currentPrice = items[1].close
            
            // ---> Lagging Span (currentPrice to be compared)
            //--------------------
            laggingSpan = items[1].close
            
            // ---> Indicator Calculations
            //-----------------------------
            
            // ---> Lines
            var lines : Bool = false // true = up, false = down
            
            if conversionLine > baseLine {
                lines = true
            }
            if conversionLine < baseLine {
                lines = false
            }
            // ---> Cloud (for future tendency)
            var cloud : Bool = false // true = up, false = down
            
            if spanA > spanB {
                cloud = true
            }
            if spanA < spanB {
                cloud = false
            }
            
            // ---> Price Over Lines
            var priceOverLines : Bool = false // true = up, false = down
            
            if conversionLine < currentPrice && baseLine < currentPrice {
                priceOverLines = true
            }
            if conversionLine > currentPrice && baseLine > currentPrice {
                priceOverLines = false
            }
            // ---> Price Over Cloud
            var priceOverCloud : Bool = false // true = up, false = down
            
            if currentPrice > spanA && currentPrice > spanB {
                priceOverCloud = true
            }
            if currentPrice < spanA && currentPrice < spanB {
                priceOverCloud = false
            }
            
            // ---> Lagging Over Price
            var laggingOverPrice : Bool = false // true = up, false = down
            
            if laggingSpan > oldPrice26 {
                laggingOverPrice = true
            }
            if laggingSpan < oldPrice26 {
                laggingOverPrice = false
            }
            
            // if laggingSpan > conversionLine = up ?
            // if laggingSpan > spanA = up ?
            
            // ---> Final indicator
            if lines == true && cloud == true && priceOverLines == true && priceOverCloud == true && laggingOverPrice == true {
                CryptoIchimoku.ichimokuDict[crypto] = 5
            }
            if lines == true && priceOverLines == true && laggingOverPrice == true {
                CryptoIchimoku.ichimokuDict[crypto] = 4
            }
            if lines == false && cloud == false && priceOverLines == false && priceOverCloud == false && laggingOverPrice == false {
                CryptoIchimoku.ichimokuDict[crypto] = 0
            }
            if lines == false && priceOverLines == false && laggingOverPrice == false {
                CryptoIchimoku.ichimokuDict[crypto] = 1
            }

    }
}
