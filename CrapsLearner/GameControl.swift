//
//  GameControl.swift
//  CrapsLearner
//
//  Created by macuser on 9/4/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import Foundation

class GameControl {
    
    var _players = [Player]()
    
    var _numPlayers = 5
    
    init() {
        
        //instantiate players
        let player = Player(bankroll: 5000, minBet: 5, minSmallBet: 1)
        
        for _ in 1..._numPlayers {
            _players.append(player)
        }
        
    }
    
    func playCraps() {
        let crapsEngine = CrapsEngine(players: _players)
        
        let decisionMaker = DecisionMaker(sensitivity: 1, betMultiplier: 1, oddsMultiplier: 3, minRollsToMakeDecisions: 5)
        
        while (_players.count > 0) {
            
            //roll
            crapsEngine.diceRoll()
            
            //calculate outcomes
            _players = crapsEngine.consequences()
            
            //adjust bets for players
            
            for player in _players {
                player.payouts(crapsEngine.outcomes)
                decisionMaker.setRatioAndReact(player, rollVal: crapsEngine.rollVal)
            }
            
            for (i, player) in _players.enumerate().reverse() {
                if (player.bankroll <= 0) {
                    _players.removeAtIndex(i)
                }
            }
            
        }
        
    }
    
}