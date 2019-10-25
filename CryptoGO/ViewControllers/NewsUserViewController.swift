//
//  NewsUserViewController.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 13/03/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications
import Crashlytics
import Answers

protocol NewsCellDelegate {
    func openLink(_ newsTableViewCell: NewsTableViewCell)
}

class NewsUserViewController: UIViewController, UITextFieldDelegate  {
    
    var alert: UIAlertController!
    var action: UIAlertAction!
    var action2: UIAlertAction!
    var nameTextFeld:UITextField!
    var linkTextFeld:UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    var sources : [NewsCellMO] = []
    
    override func viewDidLoad() {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if CDHandler.fetchSource() != nil {
            sources = CDHandler.fetchSource()!
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if CDHandler.fetchSource() != nil {
            sources = CDHandler.fetchSource()!
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.isScrollEnabled = true
        tableView.contentSize = CGSize(width: tableView.contentSize.width, height: tableView.contentSize.height + 80)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if !((nameTextFeld.text?.isEmpty)!) && ((linkTextFeld.text?.contains("http"))!) {
            action2.isEnabled = true
        }
        return true
    }
    
    func refreshData() {
        
        if CDHandler.fetchSource() != nil {
            sources = CDHandler.fetchSource()!
            tableView.reloadData()
        }
    }
    
    @IBAction func addSourceTapped(_ sender: Any) {
        
        alert = UIAlertController(title: "Add a News Source", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            self.nameTextFeld = textField
            self.nameTextFeld.placeholder = "Name"
            self.nameTextFeld.delegate = self
        }
        alert.addTextField { (textField) in
            self.linkTextFeld = textField
            self.linkTextFeld.placeholder = "Link"
            self.linkTextFeld.delegate = self
        }
        
        action2 = UIAlertAction(title: "Add", style: .default) { (_) in
            let name = self.alert.textFields!.first!.text!
            let link = self.alert.textFields!.last!.text!
            
            if CDHandler.saveSource(name: "\(name)", link: "\(link)") {
                for _ in CDHandler.fetchSource()! {
                    Answers.logCustomEvent(withName: "User Added His Own News Source", customAttributes: nil)
                }
            }
            self.refreshData()
        }
        
        action = UIAlertAction(title: "Dismiss", style: .default)
        
        action2.isEnabled = false
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
 
}


//-----------------------------

extension NewsUserViewController: UITableViewDelegate, UITableViewDataSource, NewsCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        cell.sourceNameLabel.text = sources[indexPath.row].name
        
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let selectedManagedObject = sources[indexPath.row]
            CDHandler.deleteSource(entity:"NewsCellMO", deleteObject: selectedManagedObject)
            sources.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func openLink(_ newsTableViewCell: NewsTableViewCell) {
        
        let indexPath = tableView.indexPath(for: newsTableViewCell)
        let link = sources[(indexPath?.row)!].link
        
        if let url = URL(string: "\(link)") {
            UIApplication.shared.open(url, options: [:])
            Answers.logCustomEvent(withName: "User Opened His Own News Source", customAttributes: nil)
        }
    }
}

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sourceNameLabel: UILabel!
    
    @IBOutlet weak var siteGOButton: UIButton!
    
    var delegate: NewsCellDelegate?
    
    @IBAction func linkButtonTapped(_ sender: Any) {
        delegate?.openLink(self)
    }
}


