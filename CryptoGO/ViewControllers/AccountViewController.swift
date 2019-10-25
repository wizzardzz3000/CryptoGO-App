//
//  AccountViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 23/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

