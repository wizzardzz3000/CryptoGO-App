//
//  LoadViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 18/12/2017.
//  Copyright © 2017 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit

class LoadViewController: UIViewController {
    
    @IBOutlet weak var beginButtonTapped: UIButton!
    @IBOutlet weak var textImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var mainBackground: UIImageView!
    @IBOutlet var loadViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.0) {
            let background = self.mainBackground
            background?.alpha = 0
        }
        beginButtonAnimation()
    }
    
    func beginButtonAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            self.beginButtonTapped.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.beginButtonTapped.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    @IBAction func beginButtonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
            self.beginButtonTapped.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @IBAction func beginButtonTapped(_ sender: UIButton) {
        removeTextImage()
        removeButton()
        delayMoveLogoImage()
        delayBackgroundAppears()
        delayRemoveLogoImage()
        delaySegue()
    }
    
    @objc func removeTextImage() {
        UIView.animate(withDuration: 0.8) {
            let image = self.textImage
            image?.alpha = 0
        }
    }
    
    @objc func removeButton() {
        UIView.animate(withDuration: 0.8) {
            let button = self.beginButtonTapped
            button?.alpha = 0
        }
    }
    
    @objc func moveLogoImage() {
        UIView.animate(withDuration: 2.50) {
           self.logoImage.center = self.loadViewController.center
        }
    }
    
    @objc func backgroundAppears() {
        UIView.animate(withDuration: 1.50) {
            let background = self.mainBackground
            background?.alpha = 1
        }
    }
    
    @objc func removeLogoImage() {
        UIView.animate(withDuration: 0.75) {
            let logo = self.logoImage
            logo?.alpha = 0
        }
    }
    
    func delayMoveLogoImage() {
        let myTimer = Timer(timeInterval: 0.0, target: self, selector: #selector(moveLogoImage), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func delayBackgroundAppears() {
        let myTimer = Timer(timeInterval: 1.5, target: self, selector: #selector(backgroundAppears), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func delayRemoveLogoImage() {
        let myTimer = Timer(timeInterval: 2.75, target: self, selector: #selector(removeLogoImage), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func delaySegue() {
        let myTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(presentNavigationController), userInfo: nil, repeats: false)
        RunLoop.main.add(myTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }

    // ---> "Segue"
    //--------------
    @objc func presentNavigationController() {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "navigationController")
        self.present(navigationController!, animated: false)
    }
}
