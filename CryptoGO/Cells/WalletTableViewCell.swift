//
//  WalletTableViewCell.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 28/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import UIKit

protocol CryptoCellDelegate {
    
    func cellAmountEntered(_ walletTableViewCell: WalletTableViewCell)
    func updateCellValueLabel(_ walletTableViewCell: WalletTableViewCell, atRow row: Int)
}

class WalletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cryptoNameLabel: UILabel!
    @IBOutlet weak var cryptoValueLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var cryptoCodeLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
   
    var delegate: CryptoCellDelegate?
    
    /*
    func setCrypto(crypto: CryptosMO) {
        
        cryptoNameLabel.text = crypto.name
        cryptoCodeLabel.text = crypto.symbol
        amountTextField.placeholder = crypto.placeholder
    }
    */
    
    @IBAction func amountTextFieldEntered(_ sender: Any, _ walletTableViewCell: WalletTableViewCell) {
        delegate?.cellAmountEntered(self)

    }
    
    
}
