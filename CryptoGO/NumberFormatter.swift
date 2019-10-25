//
//  NumberFormatter.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 27/12/2017.
//  Copyright © 2017 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
extension Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}
