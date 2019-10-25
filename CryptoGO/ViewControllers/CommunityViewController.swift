//
//  CommunityViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 24/02/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import Answers

class CommunityViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var trendImage: UIImageView!
    @IBOutlet weak var positionImage: UIImageView!
    
    @IBOutlet weak var votesNbLabel: UILabel!
    @IBOutlet weak var marketTrendLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    override func viewDidLoad() {
        enableVoteButton()
        refreshLabels()
    }
    
    func refreshLabels() {
        
        var intVotesNb = 0
        var strTrend = ""
        var strPosition = ""
        
        if UserDefaults.standard.string(forKey: "votesNb") != nil {
            let currentVotesNb = UserDefaults.standard.string(forKey: "votesNb")
            intVotesNb = Int(currentVotesNb!)!
            
            if intVotesNb > 0 { // <--- To update
                votesNbLabel.text = "\(intVotesNb) votes"
                //votesNbLabel.text = "7821 votes"
            }
        }
        
        /*
        trendImage.image = UIImage(named: "Trend-Down")
        marketTrendLabel.text = "Market Trend: Down"
        positionImage.image = UIImage(named: "Round-Buy")
        positionLabel.text = "Position: Buy"
        */
        
        if UserDefaults.standard.string(forKey: "votesTrend") != nil {
            let currentVotesTrend = UserDefaults.standard.string(forKey: "votesTrend")
            strTrend = String(currentVotesTrend!)
            
            if currentVotesTrend == "Up" {
                 trendImage.image = UIImage(named: "Trend-Up")
            } else if currentVotesTrend == "Stable" {
                trendImage.image = UIImage(named: "Trend-Stable")
            } else {
                trendImage.image = UIImage(named: "Trend-Down")
            }
            marketTrendLabel.text = "Market Trend: \(strTrend)"
        }
        
        if UserDefaults.standard.string(forKey: "votesPosition") != nil {
            let currentVotesPosition = UserDefaults.standard.string(forKey: "votesPosition")
            strPosition = String(currentVotesPosition!)
            
            if currentVotesPosition == "Sell" {
                positionImage.image = UIImage(named: "Round-Sell")
            } else if currentVotesPosition == "Buy" {
                positionImage.image = UIImage(named: "Round-Buy")
            } else {
                positionImage.image = UIImage(named: "Round-Hold")
            }
            positionLabel.text = "Position: \(strPosition)"
        }
        
    }
 
    func enableVoteButton() {
        if MainViewController.voteButtonEnabled == false {
            segmentedControl.setEnabled(false, forSegmentAt: 1)
        } else {
            segmentedControl.setEnabled(true, forSegmentAt: 1)
        }
    }
    
    @IBAction func segmentedTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.dismiss(animated: true, completion: nil)
        case 1:
            let marketViewController = self.storyboard?.instantiateViewController(withIdentifier: "marketViewController")
            self.present(marketViewController!, animated: true)
            segmentedControl.selectedSegmentIndex = -1
            Answers.logCustomEvent(withName: "User -> VOTES from CommunityVC", customAttributes: nil)
        default:
            break
        }
    }
    
}
