//
//  CryptoFetchingFunctions.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 27/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation

enum MyError : Error {
    case FoundNil(String)
}

struct Crypto : Decodable {
    private enum CodingKeys : String, CodingKey { case raw = "RAW" }
    let raw : CryptoRAW
}

struct CryptoRAW : Decodable {
    private enum CodingKeys : String, CodingKey {
        case btc = "BTC"
        case bch = "BCH"
        case eth = "ETH"
        case ltc = "LTC"
        case xrp = "XRP"
        case ada = "ADA"
        case neo = "NEO"
        case xlm = "XLM"
        case xmr = "XMR"
        case iota = "IOTA"
        case dash = "DASH"
        case nem = "XEM"
        case etc = "ETC"
        case qtum = "QTUM"
        case xrb = "XRB"
        case lsk = "LSK"
        case btg = "BTG"
        case zec = "ZEC"
        case steem = "STEEM"
        case stratis = "STRAT"
        case xvg = "XVG"
        case waves = "WAVES"
        case sc = "SC"
        case doge = "DOGE"
        case sls = "SLS"
        case nxs = "NXS"
        case zcl = "ZCL"
        case hsr = "HSR"
        case bts = "BTS"
        case dcr = "DCR"
        case omg = "OMG"
    }
    let btc : CryptoCURRENCIES?
    let bch : CryptoCURRENCIES?
    let eth : CryptoCURRENCIES?
    let ltc : CryptoCURRENCIES?
    let xrp : CryptoCURRENCIES?
    let ada : CryptoCURRENCIES?
    let neo : CryptoCURRENCIES?
    let xlm : CryptoCURRENCIES?
    let xmr : CryptoCURRENCIES?
    let iota : CryptoCURRENCIES?
    let dash : CryptoCURRENCIES?
    let nem : CryptoCURRENCIES?
    let etc : CryptoCURRENCIES?
    let qtum : CryptoCURRENCIES?
    let xrb : CryptoCURRENCIES?
    let lsk : CryptoCURRENCIES?
    let btg : CryptoCURRENCIES?
    let zec : CryptoCURRENCIES?
    let steem : CryptoCURRENCIES?
    let stratis : CryptoCURRENCIES?
    let xvg : CryptoCURRENCIES?
    let waves : CryptoCURRENCIES?
    let sc : CryptoCURRENCIES?
    let doge : CryptoCURRENCIES?
    let sls : CryptoCURRENCIES?
    let nxs : CryptoCURRENCIES?
    let zcl : CryptoCURRENCIES?
    let hsr : CryptoCURRENCIES?
    let bts : CryptoCURRENCIES?
    let dcr : CryptoCURRENCIES?
    let omg : CryptoCURRENCIES?
}

struct CryptoCURRENCIES : Decodable {
    private enum CodingKeys : String, CodingKey {
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
        case cny = "CNY"
        case rub = "RUB"
    }
    let usd : CryptoCURRENCY?
    let eur : CryptoCURRENCY?
    let gbp : CryptoCURRENCY?
    let cny : CryptoCURRENCY?
    let rub : CryptoCURRENCY?
}

struct CryptoCURRENCY : Decodable {
    let price : Double
    let percentChange24h : Double
    
    private enum CodingKeys : String, CodingKey {
        case price = "PRICE"
        case percentChange24h = "CHANGEPCT24HOUR"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        percentChange24h = try container.decode(Double.self, forKey: .percentChange24h)
        do {
            price = try container.decode(Double.self, forKey: .price)
        } catch DecodingError.typeMismatch(_, _) {
            let stringValue = try container.decode(String.self, forKey: .price)
            price = Double(stringValue)!
        }
    }
}

class CryptoInfo : NSObject {
    
    enum FetchError: Error {
        case urlError
        case unknownNetworkError
    }
    
    static var doublePrice : Double = 0
    static var doublePercent : Double = 0
    
    static var cryptoPriceDic : [String : Double] =
        
        ["bitcoin": MainViewController.bitcoinDoublePrice,
         "bitcoinCash": MainViewController.bitcoinCashDoublePrice,
         "ethereum": MainViewController.ethereumDoublePrice,
         "litecoin": MainViewController.litecoinDoublePrice,
         "ripple": MainViewController.rippleDoublePrice,
         "cardano": MainViewController.cardanoDoublePrice,
         "neo": MainViewController.neoDoublePrice,
         "stellar": MainViewController.stellarDoublePrice,
         "monero": MainViewController.moneroDoublePrice,
         "iota": MainViewController.iotaDoublePrice,
         "dash": MainViewController.dashDoublePrice,
         "nem": MainViewController.nemDoublePrice,
         "ethereumClassic": MainViewController.ethereumClassicDoublePrice,
         "qtum": MainViewController.qtumDoublePrice,
         "nano": MainViewController.nanoDoublePrice,
         "lisk": MainViewController.liskDoublePrice,
         "bitcoinGold": MainViewController.bitcoinGoldDoublePrice,
         "zcash": MainViewController.zcashDoublePrice,
         "steem": MainViewController.steemDoublePrice,
         "stratis": MainViewController.stratisDoublePrice,
         "verge": MainViewController.vergeDoublePrice,
         "waves": MainViewController.wavesDoublePrice,
         "siacoin": MainViewController.siacoinDoublePrice,
         "dogecoin": MainViewController.dogecoinDoublePrice,
         "salus": MainViewController.salusDoublePrice,
         "nexus": MainViewController.nexusDoublePrice,
         "zclassic": MainViewController.zclassicDoublePrice,
         "hshare": MainViewController.hshareDoublePrice,
         "bitshares": MainViewController.bitsharesDoublePrice,
         "decred": MainViewController.decredDoublePrice,
         "omisego": MainViewController.omisegoDoublePrice,
         "eos": MainViewController.eosDoublePrice,
         "tron": MainViewController.tronDoublePrice,
         "augur": MainViewController.augurDoublePrice]
    
    static var cryptoPercentDic : [String : Double] =
        
        ["bitcoin": MainViewController.btcPercent,
         "bitcoinCash": MainViewController.bchPercent,
         "ethereum": MainViewController.ethPercent,
         "litecoin": MainViewController.ltcPercent,
         "ripple": MainViewController.xrpPercent,
         "cardano": MainViewController.adaPercent,
         "neo": MainViewController.neoPercent,
         "stellar": MainViewController.xlmPercent,
         "monero": MainViewController.xmrPercent,
         "iota": MainViewController.iotaPercent,
         "dash": MainViewController.dashPercent,
         "nem": MainViewController.xemPercent,
         "ethereumClassic": MainViewController.etcPercent,
         "qtum": MainViewController.qtumPercent,
         "nano": MainViewController.xrbPercent,
         "lisk": MainViewController.lskPercent,
         "bitcoinGold": MainViewController.btgPercent,
         "zcash": MainViewController.zecPercent,
         "steem": MainViewController.steemPercent,
         "stratis": MainViewController.stratPercent,
         "verge": MainViewController.xvgPercent,
         "waves": MainViewController.wavesPercent,
         "siacoin": MainViewController.scPercent,
         "dogecoin": MainViewController.dogePercent,
         "salus": MainViewController.slsPercent,
         "nexus": MainViewController.nxsPercent,
         "zclassic": MainViewController.zclPercent,
         "hshare": MainViewController.hsrPercent,
         "bitshares": MainViewController.btsPercent,
         "decred": MainViewController.dcrPercent,
         "omisego": MainViewController.omgPercent,
         "eos": MainViewController.eosPercent,
         "tron": MainViewController.trxPercent,
         "augur": MainViewController.repPercent]
    
    func fetchCryptoInfo(_ cryptoStr: String, _ cryptoPrice: String, _ cryptoPercent: String, forCrypto cryptoSym: String, forCurrency currency: String, _ completion: @escaping (Crypto?, Error?) -> Void) {
        
        guard var cryptoDoublePrice = CryptoInfo.cryptoPriceDic[cryptoPrice] else { return }
        guard var cryptoDoublePercent = CryptoInfo.cryptoPercentDic[cryptoPercent] else { return }
        guard let cryptoStr = WalletTableViewController.cryptoStringDic[cryptoStr] else { return }
        
        guard let url = URL(string: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=\(cryptoSym)&tsyms=\(currency)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error ?? FetchError.unknownNetworkError)
                return
            }
            do {
                if let outerJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let cryptoJSON : [String: Any] = outerJSON["RAW"] as? [String : Any] {
                        if let currencyJSON : [String: Any] = cryptoJSON[cryptoSym] as? [String : Any] {
                            if let actualJSON : [String: Any] = currencyJSON[currency] as? [String : Any] {
                                if let price = actualJSON["PRICE"] as? Double {
                                    cryptoDoublePrice = price
                                    CryptoInfo.cryptoPriceDic[cryptoPrice] = cryptoDoublePrice
                                }
                                if let price = actualJSON["PRICE"] as? String {
                                    cryptoDoublePrice = Double(price)!
                                    CryptoInfo.cryptoPriceDic[cryptoPrice] = cryptoDoublePrice
                                }
                                if let percent = actualJSON["CHANGEPCT24HOUR"] as? Double {
                                    cryptoDoublePercent = percent
                                    CryptoInfo.cryptoPercentDic[cryptoPercent] = cryptoDoublePercent
                                }
                                if let percent = actualJSON["CHANGEPCT24HOUR"] as? String {
                                    cryptoDoublePercent = Double(percent)!
                                    CryptoInfo.cryptoPercentDic[cryptoPercent] = cryptoDoublePercent
                                }
                            }
                        }
                    }
                }
            } catch let parseError {
                completion(nil, parseError)
            }
            if cryptoStr == "bitcoin" || cryptoStr == "bitcoinCash" || cryptoStr == "ethereum" || cryptoStr == "litecoin" || cryptoStr == "ripple" {
                UpdateVariablesFunctions().updateCryptoVariables(cryptoStr)
            }
            
        }
        task.resume()
    }
}

class CryptoDataCall : NSObject {
    
    func dataUpdate(_ cryptoStr: String, _ cryptoSym: String) {
        
        guard let cryptoSym = WalletTableViewController.cryptoSymbol[cryptoSym] else { return }
        guard let cryptoStr = WalletTableViewController.cryptoStringDic[cryptoStr] else { return }
        
        CryptoInfo().fetchCryptoInfo(cryptoStr, cryptoStr, cryptoStr, forCrypto: "\(cryptoSym)", forCurrency: "\(SettingsViewController.currencySymbol)", { (crypto, error) in
            guard crypto != nil else { return }
        })
    }
}

class UpdateVariablesFunctions : NSObject {
    
    static var bitcoinPriceString : String = ""
    static var bitcoinPercentString : String = ""
    
    static var bitcoinCashPriceString : String = ""
    static var bitcoinCashPercentString : String = ""
    
    static var ethereumPriceString : String = ""
    static var ethereumPercentString : String = ""
    
    static var litecoinPriceString : String = ""
    static var litecoinPercentString : String = ""
    
    static var ripplePriceString : String = ""
    static var ripplePercentString : String = ""
    
    static var pricesDic : [String : String] = ["bitcoin": UpdateVariablesFunctions.bitcoinPriceString,
                                                "bitcoinCash": UpdateVariablesFunctions.bitcoinCashPriceString,
                                                "ethereum": UpdateVariablesFunctions.ethereumPriceString,
                                                "litecoin": UpdateVariablesFunctions.litecoinPriceString,
                                                "ripple": UpdateVariablesFunctions.ripplePriceString]
    
    static var percentDic : [String : String] = ["bitcoin": UpdateVariablesFunctions.bitcoinPercentString,
                                                 "bitcoinCash": UpdateVariablesFunctions.bitcoinCashPercentString,
                                                 "ethereum": UpdateVariablesFunctions.ethereumPercentString,
                                                 "litecoin": UpdateVariablesFunctions.litecoinPercentString,
                                                 "ripple": UpdateVariablesFunctions.ripplePercentString]
    
    func updateCryptoVariables(_ crypto: String) {
        
        guard let cryptoDoublePrice = CryptoInfo.cryptoPriceDic[crypto] else { return }
        guard let cryptoDoublePercent = CryptoInfo.cryptoPercentDic[crypto] else { return }
        
        guard var priceStr = UpdateVariablesFunctions.pricesDic[crypto] else { return }
        guard var percentStr = UpdateVariablesFunctions.percentDic[crypto] else { return }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 4
        formatter.locale = Locale(identifier: "\(SettingsViewController.currencyCode)")
        
        priceStr = formatter.string(from: NSNumber(value: cryptoDoublePrice))!
        UpdateVariablesFunctions.pricesDic[crypto] = priceStr
        
        percentStr = cryptoDoublePercent > 0 ? String(format: "+%.2f%%", cryptoDoublePercent) : String(format: "%.2f%%", cryptoDoublePercent)
        UpdateVariablesFunctions.percentDic[crypto] = percentStr

    }
}

