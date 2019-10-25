//
//  NewsCGOViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 14/03/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import Answers

protocol CGONewsCellDelegate {
    func openLink(_ newsTableViewCell: CGONewsTableViewCell)
}

class NewsCryptoGOViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.isScrollEnabled = true
        tableView.contentSize = CGSize(width: tableView.contentSize.width, height: tableView.contentSize.height + 60)
    }
    
    let keysAndValues = ["Twitter(cryptocurrency)" : "https://twitter.com/search?vertical=default&q=cryptocurrency&src=typd",
                         "Twitter(bitcoin)" : "https://twitter.com/search?q=bitcoin&src=typd",
                         "CryptoPanic" : "https://cryptopanic.com/",
                         "Cointelegraph" : "https://cointelegraph.com/",
                         "CoinDesk" : "https://www.coindesk.com/",
                         "Bitcointalk" : "https://bitcointalk.org/",
                         "BitcoinNews" : "https://news.bitcoin.com/",
                         "ETHNews" : "https://www.ethnews.com/",
                         "Bitcoinist" : "http://bitcoinist.com/",
                         "BitcoinMagazine" : "https://bitcoinmagazine.com/",
                         "NewsBTC" : "https://www.newsbtc.com/",
                         "TheMerkle" : "http://themerkle.com/",
                         "CCN" : "https://www.ccn.com/",
                         "cryptohappening" :  "http://cryptohappening.com/",
                         "reddit(cryptocurrency)" : "https://www.reddit.com/r/CryptoCurrency/",
                         "reddit(cryptomarkets)": "https://www.reddit.com/r/CryptoMarkets/",
                         "CryptoFlash" : "https://cryptoflash.io/",
                         "BTCManager" : "https://btcmanager.com/news/",
                         "CryptoReader" : "https://cryptoreader.com/",
                         "GeekWrapped" : "https://www.geekwrapped.com/cryptocurrency#News"]
    
    let luvDict = ["Twitter(cryptocurrency)" : "",
                   "Twitter(bitcoin)" : "",
                   "CryptoPanic" : "❤️",
                   "Cointelegraph" : "",
                   "CoinDesk" : "❤️",
                   "Bitcointalk" : "",
                   "BitcoinNews" : "❤️",
                   "ETHNews" : "",
                   "Bitcoinist" : "",
                   "BitcoinMagazine" : "",
                   "NewsBTC" : "",
                   "TheMerkle" : "",
                   "CCN" : "",
                   "cryptohappening" :  "❤️",
                   "reddit(cryptocurrency)" : "❤️",
                   "reddit(cryptomarkets)": "❤️",
                   "CryptoFlash" : "",
                   "BTCManager" : "",
                   "CryptoReader" : "",
                   "GeekWrapped" : ""]
    
}

extension NewsCryptoGOViewController: UITableViewDelegate, UITableViewDataSource, CGONewsCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keysAndValues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cgoCell", for: indexPath) as! CGONewsTableViewCell
        
        let sortedDict = keysAndValues.sorted(by: <)
        let sortedLuv = luvDict.sorted(by: <)
        
        cell.images.image = UIImage(named: "\(sortedDict[indexPath.row].key)")
        
        if sortedLuv[indexPath.row].value != "" {
            cell.cgoRound.image = UIImage(named: "CGO-Round")
            cell.heart.text = "❤️"
        } else {
            cell.cgoRound.image = UIImage(named: "")
            cell.heart.text = ""
        }
        
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func openLink(_ newsTableViewCell: CGONewsTableViewCell) {
        
        let indexPath = tableView.indexPath(for: newsTableViewCell)
        
        let sortedDict = keysAndValues.sorted(by: <)
        
        let link = sortedDict[(indexPath?.row)!].value
        
        if let url = URL(string: "\(link)") {
            UIApplication.shared.open(url, options: [:])
            Answers.logCustomEvent(withName: "User Opened CGO News Link", customAttributes: nil)
        }
    }
}

class CGONewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var buttons: UIButton!
    @IBOutlet weak var cgoRound: UIImageView!
    @IBOutlet weak var heart: UILabel!
    
    var delegate: CGONewsCellDelegate?
    
    @IBAction func linkButtonTapped(_ sender: Any) {
        delegate?.openLink(self)
    }
}
