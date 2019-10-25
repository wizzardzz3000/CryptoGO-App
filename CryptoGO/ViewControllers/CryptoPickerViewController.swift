//
//  CryptoPickerViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 28/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import CoreData

typealias CryptosMOInfo = (name:String, code:String, symbol:String, placeholder:String, amount:String, amountValue:String)

class CryptoPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var cryptoPicker: UIPickerView!
    
    @IBOutlet weak var label: UILabel!
    
    static var selectedCrypto : String = ""

    var cryptoSelected: Bool = false
    
    //----------------------------
    
    override func viewDidLoad() {
        enableAddButton()
        self.cryptoPicker.selectRow(17, inComponent: 0, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        enableAddButton()
    }
    
    //------------------
    // Picker Functions
    //------------------
    let pickerCryptos = ["Augur REP", "Bitcoin BTC", "Bitcoin Cash BCH", "Bitcoin Gold BTG", "BitShares BTS", "Cardano ADA", "Dash DASH", "Decred DCR", "Dogecoin DOGE", "EOS EOS", "Ethereum ETH", "Ethereum Classic ETC", "Hshare HSR", "Lisk LSK", "Litecoin LTC", "Monero XMR", "Nano XRB", "NEM XEM", "NEO NEO", "Nexus NXS", "OmiseGO OMG", "IOTA IOTA", "Qtum QTUM", "Ripple XRP", "Salus SLS", "Siacoin SC", "Steem STEEM", "Stellar XLM", "Stratis STRAT", "TRON TRX", "Verge XVG", "Waves WAVES", "ZCash ZEC", "ZClassic ZCL"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerCryptos[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerCryptos.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        label.text = pickerCryptos[row]
        CryptoPickerViewController.selectedCrypto = pickerCryptos[row]
        cryptoSelected = true
        enableAddButton()
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = pickerCryptos[row]
        
        return label
    }
    
    func enableAddButton() {
        if cryptoSelected == true {
            segmentedControl.setEnabled(true, forSegmentAt: 1)
        } else {
            segmentedControl.setEnabled(false, forSegmentAt: 1)
        }
    }
    
    //-----------------------
    // Crypto Array Functions
    //-----------------------
    
    func createCryptoArray(_ addedCrypto: String) {
        
        let cryptosDictionary: [String : CryptosMOInfo] = [ "Augur REP" : (name: "Augur", code: "augur", symbol: "REP", placeholder: "REP Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Bitcoin BTC" : (name: "Bitcoin", code: "bitcoin", symbol: "BTC", placeholder: "BTC Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Bitcoin Cash BCH" : (name: "Bitcoin Cash", code: "bitcoinCash", symbol: "BCH", placeholder: "BCH Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Bitcoin Gold BTG" : (name: "Bitcoin Gold", code: "bitcoinGold", symbol: "BTG", placeholder: "BTG Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "BitShares BTS" : (name: "BitShares", code: "bitshares", symbol: "BTS", placeholder: "BTS Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Cardano ADA" : (name: "Cardano", code: "cardano", symbol: "ADA", placeholder: "ADA Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Dash DASH" : (name: "Dash", code: "dash", symbol: "DASH", placeholder: "DASH Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Decred DCR" : (name: "Decred", code: "decred", symbol: "DCR", placeholder: "DCR Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Dogecoin DOGE" : (name: "Dogecoin", code: "dogecoin", symbol: "DOGE", placeholder: "DOGE Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "EOS EOS" : (name: "EOS", code: "eos", symbol: "EOS", placeholder: "EOS Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Ethereum ETH" : (name: "Ethereum", code: "ethereum", symbol: "ETH", placeholder: "ETH Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Ethereum Classic ETC" : (name: "Ethereum Classic", code: "ethereumClassic", symbol: "ETC", placeholder: "ETC Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Hshare HSR" : (name: "Hshare", code: "hshare", symbol: "HSR", placeholder: "HSR Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Lisk LSK" : (name: "Lisk", code: "lisk", symbol: "LSK", placeholder: "LSK Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Litecoin LTC" : (name: "Litecoin", code: "litecoin", symbol: "LTC", placeholder: "LTC Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Monero XMR" : (name: "Monero", code: "monero", symbol: "XMR", placeholder: "XMR Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Nano XRB" : (name: "Nano", code: "nano", symbol: "XRB", placeholder: "XRB Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "NEM XEM" : (name: "NEM", code: "nem", symbol: "XEM", placeholder: "XEM Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "NEO NEO" : (name: "NEO", code: "neo", symbol: "NEO", placeholder: "NEO Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Nexus NXS" : (name: "Nexus", code: "nexus", symbol: "NXS", placeholder: "NXS Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "OmiseGO OMG" : (name: "OmiseGO", code: "omisego", symbol: "OMG", placeholder: "OMG Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "IOTA IOTA" : (name: "IOTA", code: "iota", symbol: "IOTA", placeholder: "IOTA Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Qtum QTUM" : (name: "Qtum", code: "qtum", symbol: "QTUM", placeholder: "QTUM Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Ripple XRP" : (name: "Ripple", code: "ripple", symbol: "XRP", placeholder: "XRP Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Salus SLS" : (name: "Salus", code: "salus", symbol: "SLS", placeholder: "SLS Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Siacoin SC" : (name: "Siacoin", code: "siacoin", symbol: "SC", placeholder: "SC Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Steem STEEM" : (name: "Steem", code: "steem", symbol: "STEEM", placeholder: "STEEM Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Stellar XLM" : (name: "Stellar", code: "stellar", symbol: "XLM", placeholder: "XLM Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Stratis STRAT" : (name: "Stratis", code: "stratis", symbol: "STRAT", placeholder: "STRAT Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "TRON TRX" : (name: "TRON", code: "tron", symbol: "TRX", placeholder: "TRX Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Verge XVG" : (name: "Verge", code: "verge", symbol: "XVG", placeholder: "XVG Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "Waves WAVES" : (name: "Waves", code: "waves", symbol: "WAVES", placeholder: "WAVES Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "ZCash ZEC" : (name: "ZCash", code: "zcash", symbol: "ZEC", placeholder: "ZEC Amount", amount: "0.00000000", amountValue: "0.0"),
                                                            "ZClassic ZCL" : (name: "ZClassic", code: "zclassic", symbol: "ZCL", placeholder: "ZCL Amount", amount: "0.00000000", amountValue: "0.0")]
        
        let obj = cryptosDictionary[addedCrypto]
        guard let object = obj else { return }
      
        if addedCrypto != "" {
            if CDHandler.saveObject(cryptosInfo: object) {
                for _ in CDHandler.fetchObject()! {
                }
            }
        }
    }
    
    //----------------------------
    // Segmented Control Function
    //----------------------------
    @IBAction func segmentedControlTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.dismiss(animated: true, completion: nil)
        case 1: // <--- Add To Wallet
            createCryptoArray(CryptoPickerViewController.selectedCrypto)
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
}
