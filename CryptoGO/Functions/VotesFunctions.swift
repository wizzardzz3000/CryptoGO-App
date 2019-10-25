//
//  VotesFunctions.swift
//  CryptoGO
//
//  Created by Martin SCAGLIA on 19/03/2018.
//  Copyright © 2018 Martin SCAGLIA. All rights reserved.
//

import Foundation

enum APIError: Error {
    case urlError
    case unknownNetworkError
}

struct VoteData : Codable {
    let votes : [Votes]
}

struct Votes : Codable {
    let vote_nb : String
    let trend_up : String
    let trend_stable : String
    let trend_down : String
    let position_hold : String
    let position_buy : String
    let position_sell : String
}

class VotesFunctions: NSObject {
    
    var items : VoteData!
    
    var allowRefresh = true
    
    var trend_up = 0
    var trend_stable = 0
    var trend_down = 0
    var position_hold = 0
    var position_buy = 0
    var position_sell = 0
    
    static var votesNb = ""
    static var votesPosition = ""
    static var votesTrend = ""
    
    func fetchData(completion: @escaping (VoteData?, Error?) -> Void) {
        
        print("*** VOTE FETCH DATA ***")
        
        guard let url = URL(string: "https://4wo0x5dun1.execute-api.eu-west-3.amazonaws.com/prod/votes/1") else { return }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("0k5bOopsuu2NnTRbBFsgR5ZYDwGnrlBr7SQKNpKh", forHTTPHeaderField: "X-API-KEY")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else {
                completion(nil, error ?? APIError.unknownNetworkError)
                return
            }
            do {
                let result = try JSONDecoder().decode(VoteData.self, from: data); completion(result, nil)
                
                print("GET vote result =", result.votes[0].vote_nb)
                
                VotesFunctions.votesNb = result.votes[0].vote_nb
                UserDefaults.standard.set(VotesFunctions.votesNb, forKey: "votesNb")
                
                self.trend_up = Int(result.votes[0].trend_up)!
                self.trend_stable = Int(result.votes[0].trend_stable)!
                self.trend_down = Int(result.votes[0].trend_down)!
                
                self.position_hold = Int(result.votes[0].position_hold)!
                self.position_buy = Int(result.votes[0].position_buy)!
                self.position_sell = Int(result.votes[0].position_sell)!
                
                let trend = ["Up": self.trend_up, "Stable": self.trend_stable, "Down": self.trend_down]
                let sortedTrend = trend.sorted{ $0.value > $1.value }
                VotesFunctions.votesTrend = (sortedTrend.first?.key)!
                UserDefaults.standard.set(VotesFunctions.votesTrend, forKey: "votesTrend")
                
                let positions = ["Hold": self.position_hold, "Buy": self.position_buy, "Sell": self.position_sell]
                let sortedPositions = positions.sorted{ $0.value > $1.value }
                VotesFunctions.votesPosition = (sortedPositions.first?.key)!
                UserDefaults.standard.set(VotesFunctions.votesPosition, forKey: "votesPosition")
                
            } catch let parseError {
                completion(nil, parseError)
            }
        }
        task.resume()
    }
    
    func refreshVotesData() {
        
        let currentDate = Date()
        var lastDataRefresh: Date?
        var timeSinceLastRefresh: TimeInterval?
        
        if UserDefaults.standard.object(forKey: "lastVotesAPIFetch") != nil {
            lastDataRefresh = UserDefaults.standard.value(forKey: "lastVotesAPIFetch") as? Date
            
            timeSinceLastRefresh = (currentDate.timeIntervalSince(lastDataRefresh!)) / 900
            let doubleLastRefresh = Double(timeSinceLastRefresh!)
            
            if doubleLastRefresh < 1 {
                
                allowRefresh = false
                
            } else {
                allowRefresh = true
            }
        } else {
            allowRefresh = true
        }
        
        if allowRefresh == true {
            dataUpdate()
        }
    }
    
    func dataUpdate() {
        
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "lastVotesAPIFetch")
     
        fetchData() { items, error in
            guard items != nil else { return }
        }
    }
    
}


