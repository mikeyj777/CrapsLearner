//
//  GameControl.swift
//  CrapsLearner
//
//  Created by macuser on 9/4/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import Foundation

class GameControl {
    
    private var _crapsEngine:CrapsEngine
    
    private var _decisionMaker:DecisionMaker
    
    private var _players = [Player]()
    
    private var _learnings = [[String:Double]]()
    
    var learnings:[[String:Double]] {
        return _learnings
    }
    
    init(numPlayers: Int, bankroll: Double, minBet: Double, minSmallBet: Double, sensitivity: Double) {
        
    
        //instantiate players
        let player = Player(bankroll: bankroll, minBet: minBet, minSmallBet: minSmallBet, sensitivity: sensitivity)
        
        for _ in 1...numPlayers {
            _players.append(player)
        }
        
        _crapsEngine = CrapsEngine(players: _players)
        
        _decisionMaker = DecisionMaker(sensitivity: 1, betMultiplier: 1, oddsMultiplier: 3, minRollsToMakeDecisions: 5)

        
        
        
    }
    
    func playCraps() {
        
        while (_players.count > 0) {
            
            //roll
            _crapsEngine.diceRoll()
            
            //calculate outcomes
            _players = _crapsEngine.consequences()
            
            //adjust bets for players
            
            for player in _players {
                player.payouts(_crapsEngine.outcomes)
                _decisionMaker.setRatioAndReact(player, rollVal: _crapsEngine.rollVal)
            }
            
            
            for (i, player) in _players.enumerate().reverse() {
                if (player.bankroll <= 0) {
                    _learnings.append(player.rowForLearning)
                    _players.removeAtIndex(i)
                    
                }
            }
            
            if (_players.count == 0) {
                
                storeLearnings()
                
            }
            
        }
        
    }
    
    func storeLearnings() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var dict = defaults.objectForKey("learnings") as? [[String: Double]] ?? [[String: Double]]()
        
        for learning in _learnings {
            
            dict.append(learning)
            
        }
        
        defaults.setObject(dict, forKey: "learnings")
        
        defaults.synchronize()
        
    }
    
    
}