//
//  WalletTableViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 28/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Crashlytics
import Answers

class WalletTableViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var addCryptoButton: UIButton!
    
    @IBOutlet weak var walletValueLabel: UILabel!
    
    @IBOutlet weak var erc20AddressLabel: UILabel!
    @IBOutlet weak var cgoTokenAmountLabel: UILabel!
    @IBOutlet weak var tokenEmojiLabel: UILabel!
    
    @IBOutlet weak var erc20AddressTextField: UITextField!
    
    static var erc20Address: String = ""
    
    var cryptos : [CryptosMO] = []
    
    var total : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        self.hideKeyboard()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        
        if CDHandler.fetchObject() != nil {
            cryptos = CDHandler.fetchObject()!
            tableView.reloadData()
        }

        erc20AddressTextField.delegate = self
        
        update()
        
        updateWalletValue()
        updateWalletLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if CDHandler.fetchObject() != nil {
            cryptos = CDHandler.fetchObject()!
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.isScrollEnabled = true
        tableView.contentSize = CGSize(width: tableView.contentSize.width, height: tableView.contentSize.height + 60)
    }
   
    
    func update() {

        updateCGOTokenAmount()
        updateERC20AddressLabel()
        updateEmojis()
    }

    func updateEmojis() {
        if UserDefaults.standard.object(forKey: "cgoTokens") != nil {
            let lastCGOTokensAmount = UserDefaults.standard.integer(forKey: "cgoTokens")
            
            //let lastCGOTokensAmount2 = 250 // remove
            
            if lastCGOTokensAmount > 0 {
                tokenEmojiLabel.text = "😊"
            } else if lastCGOTokensAmount > 50 {
                tokenEmojiLabel.text = "😄"
            } else if lastCGOTokensAmount > 200 {
                tokenEmojiLabel.text = "😜"
            } else if lastCGOTokensAmount > 500 {
                tokenEmojiLabel.text = "🤑"
            } else if lastCGOTokensAmount > 1000 {
                tokenEmojiLabel.text = "😈"
            }
        } else {
            tokenEmojiLabel.text = "😢"
        }
    }
    
    func updateCGOTokenAmount() {
        if UserDefaults.standard.object(forKey: "cgoTokens") != nil {
            let lastCGOTokensAmount = UserDefaults.standard.integer(forKey: "cgoTokens")
            cgoTokenAmountLabel.text = String(lastCGOTokensAmount)
        }
    }
    
    func updateERC20AddressLabel() {
        if UserDefaults.standard.object(forKey: "erc20Address") != nil {
            let address = UserDefaults.standard.string(forKey: "erc20Address")
            erc20AddressLabel.text = address
            WalletTableViewController.erc20Address = address!
        } else {
            erc20AddressLabel.text = "ERC20 Wallet Address"
            WalletTableViewController.erc20Address = ""
        }
        
    }
    
    func updateWalletValue() {
        
        guard let items : [CryptosMO] = CDHandler.fetchObject() else { return }
        total = items.reduce(0.0, { $0 + Double($1.amountValue)! } )
        
    }
    
    func updateWalletLabel() {
        if SettingsViewController.currencyCode != "" {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 4
            formatter.locale = Locale(identifier: "\(SettingsViewController.currencyCode)")
            walletValueLabel.text = formatter.string(from: NSNumber(value: total))
        }
    }
    
    //Textfields functions
    //---------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == erc20AddressTextField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength == 42
        } else {
            let aSet = NSCharacterSet(charactersIn:".0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //Textfield Address Entered
    //-------------------------
    @IBAction func erc20AddressEntered(_ sender: UITextField) {
        if erc20AddressTextField.text == "" {
            return
        }
        let str = erc20AddressTextField.text
        
        erc20AddressLabel.text = str
        UserDefaults.standard.set(erc20AddressLabel.text, forKey: "erc20Address")
        
        erc20AddressTextField.text = ""
        
        updateERC20AddressLabel()
        
        Answers.logCustomEvent(withName: "User Added His ERC20 Wallet Address", customAttributes: nil)
    }
    
    //Keyboard Functions
    //---------------------
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWasShown(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo,
            let keyboardFrameValue = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue
            else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    //---------------------
    
    //Alert functions
    //---------------------
    func accountInfoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.segmentedControl.selectedSegmentIndex = -1
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addCryptoButtonTapped(_ sender: Any) {
        let cryptoPickerViewController = self.storyboard?.instantiateViewController(withIdentifier: "cryptoPickerViewController")
        self.present(cryptoPickerViewController!, animated: true)
    }
    @IBAction func segmentedControlTapped(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.dismiss(animated: true, completion: nil)
        case 1:
            if UserDefaults.standard.object(forKey: "cgoTokens") != nil {
                let cgoTokensAmount = UserDefaults.standard.integer(forKey: "cgoTokens")
                
                if cgoTokensAmount < 250 {
                    accountInfoAlert(title: "Not enough tokens! 😢", message: "You need at least 250 CGO tokens to redeem them.")
                } else {
                    accountInfoAlert(title: "Coming Soon 🙃", message: "In the meantime, please keep CryptoGO installed to keep your CGO tokens balance alive.")
                    Answers.logCustomEvent(withName: "User Had Enough Tokens To Redeem", customAttributes: nil)
                }
            } else {
                accountInfoAlert(title: "Not enough tokens! 😢", message: "You need at least 250 CGO tokens to redeem them.")
            }
        default:
            break
        }
    }
}

//-----------------------------

extension WalletTableViewController: UITableViewDelegate, UITableViewDataSource, CryptoCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WalletTableViewCell
        
        cell.cryptoNameLabel.text = cryptos[indexPath.row].name
        cell.cryptoCodeLabel.text = cryptos[indexPath.row].symbol
        cell.amountLabel.text = cryptos[indexPath.row].amount
        cell.amountTextField.placeholder = cryptos[indexPath.row].placeholder
        
        if cryptos[indexPath.row].amountValue == "0.0" {
            cell.cryptoValueLabel.text = ""
        }

        cell.delegate = self
        cell.amountTextField.delegate = self
        
        updateCellValueLabel(cell, atRow: indexPath.row)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            let selectedManagedObject = cryptos[indexPath.row]
            CDHandler.deleteObject(entity:"CryptosMO", deleteObject: selectedManagedObject)
            cryptos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateWalletValue()
            updateWalletLabel()
        }
    }

    //Textfields amounts
    //--------------------
    func cellAmountEntered(_ walletTableViewCell: WalletTableViewCell) {
        
        if walletTableViewCell.amountTextField.text == "" {
            return
        }
        
        let str = walletTableViewCell.amountTextField.text
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        let dNumber = formatter.number(from: str!)
        let nDouble = dNumber!
        let eNumber = Double(truncating: nDouble)
        walletTableViewCell.amountLabel.text = String(format:"%.8f", eNumber)
        
        var editAmount = ""
        editAmount = String(format:"%.8f", eNumber)
        
        let indexPath = tableView.indexPath(for: walletTableViewCell)
        let selectedManagedObject = cryptos[(indexPath?.row)!]
        
        CDHandler.editObject(editObject: selectedManagedObject, amount: editAmount, amountValue: "0.0")
        
        walletTableViewCell.amountTextField.text = ""
        
        tableView.reloadData()
    }
    
    // Value calculation & label update
    //----------------------------------
    func updateCellValueLabel(_ walletTableViewCell: WalletTableViewCell, atRow row: Int) {
        
        if walletTableViewCell.amountLabel.text == "" {
            walletTableViewCell.amountLabel.text = "0.00000000"
        }
        
        var newCryptos : [CryptosMO] = []
        var doubleAmount = 0.0
        
        var cryptoPrice = ""
        
        if CDHandler.fetchObject() != nil {
            newCryptos = CDHandler.fetchObject()!
        }
        
        cryptoPrice = cryptos[row].code!
        CryptoDataCall().dataUpdate(cryptoPrice, cryptoPrice)
        
        guard let cryptoDoublePrice = CryptoInfo.cryptoPriceDic[cryptoPrice] else { return }
        
        let selectedAmount = newCryptos[row]
        
        guard let amount = selectedAmount.amount else { return }
        var currentAmountValue = selectedAmount.amountValue
        
        doubleAmount = Double(amount)!
        
        let calculation = cryptoDoublePrice * doubleAmount
        currentAmountValue = String(calculation)

        
        CDHandler.editObject(editObject: selectedAmount, amount: amount, amountValue: currentAmountValue)
        
        if SettingsViewController.currencyCode != "" {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 4
            formatter.locale = Locale(identifier: "\(SettingsViewController.currencyCode)")
            walletTableViewCell.cryptoValueLabel.text = formatter.string(from: NSNumber(value: calculation))
        }
        updateWalletValue()
        updateWalletLabel()
    }
    
}

extension UIViewController {
    
    func hideKeyboard() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension WalletTableViewController {
    static var bitcoin : String = "BTC"
    static var bitcoinCash : String = "BCH"
    static var ethereum : String = "ETH"
    static var litecoin : String = "LTC"
    static var ripple : String = "XRP"
    static var cardano : String = "ADA"
    static var neo : String = "NEO"
    static var stellar : String = "XLM"
    static var monero : String = "XMR"
    static var iota : String = "IOTA"
    static var dash : String = "DASH"
    static var nem : String = "XEM"
    static var ethereumClassic : String = "ETC"
    static var qtum : String = "QTUM"
    static var nano : String = "XRB"
    static var lisk : String = "LSK"
    static var bitcoinGold : String = "BTG"
    static var zcash : String = "ZEC"
    static var steem : String = "STEEM"
    static var stratis : String = "STRAT"
    static var verge : String = "XVG"
    static var waves : String = "WAVES"
    static var siacoin : String = "SC"
    static var dogecoin : String = "DOGE"
    static var salus : String = "SLS"
    static var nexus : String = "NXS"
    static var zclassic : String = "ZCL"
    static var hshare : String = "HSR"
    static var bitshares : String = "BTS"
    static var decred : String = "DCR"
    static var omisego : String = "OMG"
    static var eos : String = "EOS"
    static var tron : String = "TRX"
    static var augur : String = "REP"
    
    static var bitcoinString : String = "bitcoin"
    static var bitcoinCashString : String = "bitcoinCash"
    static var ethereumString : String = "ethereum"
    static var litecoinString : String = "litecoin"
    static var rippleString : String = "ripple"
    static var cardanoString : String = "cardano"
    static var neoString : String = "neo"
    static var stellarString : String = "stellar"
    static var moneroString : String = "monero"
    static var iotaString : String = "iota"
    static var dashString : String = "dash"
    static var nemString : String = "nem"
    static var ethereumClassicString : String = "ethereumClassic"
    static var qtumString : String = "qtum"
    static var nanoString : String = "nano"
    static var liskString : String = "lisk"
    static var bitcoinGoldString : String = "bitcoinGold"
    static var zcashString : String = "zcash"
    static var steemString : String = "steem"
    static var stratisString : String = "stratis"
    static var vergeString : String = "verge"
    static var wavesString : String = "waves"
    static var siacoinString : String = "siacoin"
    static var dogecoinString : String = "dogecoin"
    static var salusString : String = "salus"
    static var nexusString : String = "nexus"
    static var zclassicString : String = "zclassic"
    static var hshareString : String = "hshare"
    static var bitsharesString : String = "bitshares"
    static var decredString : String = "decred"
    static var omisegoString : String = "omisego"
    static var eosString : String = "eos"
    static var tronString : String = "tron"
    static var augurString : String = "augur"
    
    static var cryptoSymbol : [String : String] =
        
        ["bitcoin": WalletTableViewController.bitcoin,
         "bitcoinCash": WalletTableViewController.bitcoinCash,
         "ethereum": WalletTableViewController.ethereum,
         "litecoin": WalletTableViewController.litecoin,
         "ripple": WalletTableViewController.ripple,
         "cardano": WalletTableViewController.cardano,
         "neo": WalletTableViewController.neo,
         "stellar": WalletTableViewController.stellar,
         "monero": WalletTableViewController.monero,
         "iota": WalletTableViewController.iota,
         "dash": WalletTableViewController.dash,
         "nem": WalletTableViewController.nem,
         "ethereumClassic": WalletTableViewController.ethereumClassic,
         "qtum": WalletTableViewController.qtum,
         "nano": WalletTableViewController.nano,
         "lisk": WalletTableViewController.lisk,
         "bitcoinGold": WalletTableViewController.bitcoinGold,
         "zcash": WalletTableViewController.zcash,
         "steem": WalletTableViewController.steem,
         "stratis": WalletTableViewController.stratis,
         "verge": WalletTableViewController.verge,
         "waves": WalletTableViewController.waves,
         "siacoin": WalletTableViewController.siacoin,
         "dogecoin": WalletTableViewController.dogecoin,
         "salus": WalletTableViewController.salus,
         "nexus": WalletTableViewController.nexus,
         "zclassic": WalletTableViewController.zclassic,
         "hshare": WalletTableViewController.hshare,
         "bitshares": WalletTableViewController.bitshares,
         "decred": WalletTableViewController.decred,
         "omisego": WalletTableViewController.omisego,
         "eos": WalletTableViewController.eos,
         "tron": WalletTableViewController.tron,
         "augur": WalletTableViewController.augur]
    
    static var cryptoStringDic : [String : String] =
        
        ["bitcoin": WalletTableViewController.bitcoinString,
         "bitcoinCash": WalletTableViewController.bitcoinCashString,
         "ethereum": WalletTableViewController.ethereumString,
         "litecoin": WalletTableViewController.litecoinString,
         "ripple": WalletTableViewController.rippleString,
         "cardano": WalletTableViewController.cardanoString,
         "neo": WalletTableViewController.neoString,
         "stellar": WalletTableViewController.stellarString,
         "monero": WalletTableViewController.moneroString,
         "iota": WalletTableViewController.iotaString,
         "dash": WalletTableViewController.dashString,
         "nem": WalletTableViewController.nemString,
         "ethereumClassic": WalletTableViewController.ethereumClassicString,
         "qtum": WalletTableViewController.qtumString,
         "nano": WalletTableViewController.nanoString,
         "lisk": WalletTableViewController.liskString,
         "bitcoinGold": WalletTableViewController.bitcoinGoldString,
         "zcash": WalletTableViewController.zcashString,
         "steem": WalletTableViewController.steemString,
         "stratis": WalletTableViewController.stratisString,
         "verge": WalletTableViewController.vergeString,
         "waves": WalletTableViewController.wavesString,
         "siacoin": WalletTableViewController.siacoinString,
         "dogecoin": WalletTableViewController.dogecoinString,
         "salus": WalletTableViewController.salusString,
         "nexus": WalletTableViewController.nexusString,
         "zclassic": WalletTableViewController.zclassicString,
         "hshare": WalletTableViewController.hshareString,
         "bitshares": WalletTableViewController.bitsharesString,
         "decred": WalletTableViewController.decredString,
         "omisego": WalletTableViewController.omisegoString,
         "eos": WalletTableViewController.eosString,
         "tron": WalletTableViewController.tronString,
         "augur": WalletTableViewController.augurString]
}










