//
//  SettingsPickerViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 09/03/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit

class SettingsPickerViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var cryptoPicker: UIPickerView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var cryptoSelected: Bool = false
    
    var selectedCrypto = ""
    var cryptoSymbol = ""
    
    static var cell1Crypto = "bitcoin"
    static var cell2Crypto = "bitcoinCash"
    static var cell3Crypto = "ethereum"
    static var cell4Crypto = "litecoin"
    static var cell5Crypto = "ripple"
    
    static var cell1CryptoSymbol = "BTC"
    static var cell2CryptoSymbol = "BCH"
    static var cell3CryptoSymbol = "ETH"
    static var cell4CryptoSymbol = "LTC"
    static var cell5CryptoSymbol = "XRP"
    
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
    let pickerCryptos = ["Augur REP", "Bitcoin BTC", "Bitcoin Cash BCH", "Bitcoin Gold BTG", "BitShares BTS", "Cardano ADA", "Dash DASH", "Decred DCR", "Dogecoin DOGE", "EOS EOS", "Ethereum ETH", "Ethereum Classic ETC", "Hshare HSR", "Lisk LSK", "Litecoin LTC", "Monero XMR", "Nano XRB", "NEM XEM", "NEO NEO", "Nexus NXS", "OmiseGO OMG", "IOTA IOTA", "Qtum QTUM", "Ripple XRP", "Salus SLS", "Siacoin SC", "Steem STEEM", "Stellar XLM", "Stratis STRAT", "Tron TRX", "Verge XVG", "Waves WAVES", "ZCash ZEC", "ZClassic ZCL"]
    
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
        selectedCrypto = pickerCryptos[row]
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
    
    //---------------------------
    // Variable Setting Function
    //---------------------------
    func setVariable(_ selectedCrypto: String, _ selectedCryptoSymbol: String) {
        
        let cryptoCodeDic : [String : String] =
            ["Augur REP": "augur",
             "Bitcoin BTC": "bitcoin",
             "Bitcoin Cash BCH" : "bitcoinCash",
             "Bitcoin Gold BTG" : "bitcoinGold",
             "BitShares BTS" : "bitshares",
             "Cardano ADA" : "cardano",
             "Dash DASH" : "dash",
             "Decred DCR" : "decred",
             "Dogecoin DOGE" : "dogecoin",
             "EOS EOS" : "eos",
             "Ethereum ETH" : "ethereum",
             "Ethereum Classic ETC" : "ethereumClassic",
             "Hshare HSR" : "hshare",
             "Lisk LSK" : "lisk",
             "Litecoin LTC" : "litecoin",
             "Monero XMR" : "monero",
             "Nano XRB" : "nano",
             "NEM XEM" : "nem",
             "NEO NEO" : "neo",
             "Nexus NXS" : "nexus",
             "OmiseGO OMG" : "omisego",
             "IOTA IOTA" : "iota",
             "Qtum QTUM" : "qtum",
             "Ripple XRP" : "ripple",
             "Salus SLS" : "salus",
             "Siacoin SC" : "siacoin",
             "Steem STEEM" : "steem",
             "Stellar XLM" : "stellar",
             "Stratis STRAT" : "stratis",
             "Tron TRX" : "tron",
             "Verge XVG" : "verge",
             "Waves WAVES" : "waves",
             "ZCash ZEC" : "zcash",
             "ZClassic ZCL" : "zclassic"]
        
        let cryptoSymbolDic : [String : String] =
            ["Augur REP": "REP",
             "Bitcoin BTC": "BTC",
             "Bitcoin Cash BCH" : "BCH",
             "Bitcoin Gold BTG" : "BTG",
             "BitShares BTS" : "BTS",
             "Cardano ADA" : "ADA",
             "Dash DASH" : "DASH",
             "Decred DCR" : "DCR",
             "Dogecoin DOGE" : "DOGE",
             "EOS EOS" : "EOS",
             "Ethereum ETH" : "ETH",
             "Ethereum Classic ETC" : "ETC",
             "Hshare HSR" : "HSR",
             "Lisk LSK" : "LSK",
             "Litecoin LTC" : "LTC",
             "Monero XMR" : "XMR",
             "Nano XRB" : "XRB",
             "NEM XEM" : "XEM",
             "NEO NEO" : "NEO",
             "Nexus NXS" : "NXS",
             "OmiseGO OMG" : "OMG",
             "IOTA IOTA" : "IOTA",
             "Qtum QTUM" : "QTUM",
             "Ripple XRP" : "XRP",
             "Salus SLS" : "SLS",
             "Siacoin SC" : "SC",
             "Steem STEEM" : "STEEM",
             "Stellar XLM" : "XLM",
             "Stratis STRAT" : "STRAT",
             "Tron TRX" : "TRX",
             "Verge XVG" : "XVG",
             "Waves WAVES" : "WAVES",
             "ZCash ZEC" : "ZEC",
             "ZClassic ZCL" : "ZCL"]
        
        let cryp = cryptoCodeDic[selectedCrypto]
        guard let crypto = cryp else { return }
        
        let cryp2 = cryptoSymbolDic[selectedCryptoSymbol]
        guard let cryptoSymbol = cryp2 else { return }
        
        if SettingsViewController.cell1 == true {
            SettingsPickerViewController.cell1Crypto = crypto
            SettingsPickerViewController.cell1CryptoSymbol = cryptoSymbol
            UserDefaults.standard.set(SettingsPickerViewController.cell1Crypto, forKey: "cell1")
            UserDefaults.standard.set(SettingsPickerViewController.cell1CryptoSymbol, forKey: "cell1symbol")
        }
        if SettingsViewController.cell2 == true {
            SettingsPickerViewController.cell2Crypto = crypto
            SettingsPickerViewController.cell2CryptoSymbol = cryptoSymbol
            UserDefaults.standard.set(SettingsPickerViewController.cell2Crypto, forKey: "cell2")
            UserDefaults.standard.set(SettingsPickerViewController.cell2CryptoSymbol, forKey: "cell2symbol")
        }
        if SettingsViewController.cell3 == true {
            SettingsPickerViewController.cell3Crypto = crypto
            SettingsPickerViewController.cell3CryptoSymbol = cryptoSymbol
            UserDefaults.standard.set(SettingsPickerViewController.cell3Crypto, forKey: "cell3")
            UserDefaults.standard.set(SettingsPickerViewController.cell3CryptoSymbol, forKey: "cell3symbol")
        }
        if SettingsViewController.cell4 == true {
            SettingsPickerViewController.cell4Crypto = crypto
            SettingsPickerViewController.cell4CryptoSymbol = cryptoSymbol
            UserDefaults.standard.set(SettingsPickerViewController.cell4Crypto, forKey: "cell4")
            UserDefaults.standard.set(SettingsPickerViewController.cell4CryptoSymbol, forKey: "cell4symbol")
        }
        if SettingsViewController.cell5 == true {
            SettingsPickerViewController.cell5Crypto = crypto
            SettingsPickerViewController.cell5CryptoSymbol = cryptoSymbol
            UserDefaults.standard.set(SettingsPickerViewController.cell5Crypto, forKey: "cell5")
            UserDefaults.standard.set(SettingsPickerViewController.cell5CryptoSymbol, forKey: "cell5symbol")
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
        case 1: // <--- Add To Main View
            setVariable(selectedCrypto, selectedCrypto)
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
}
