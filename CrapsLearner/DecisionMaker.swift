//
//  DecisionMaker.swift
//  CrapsLearner
//
//  Created by macuser on 8/31/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import Foundation

class DecisionMaker {
    
    private var _sensitivity:Double
    
    private var _betMultiplier:Double
    
    private var _oddsMultiplier:Double
    
    private var _ratio:Double
    
    private var _rollCount:Int
    
    private var _sevenCount:Int
    
    private var _minRollsToMakeDecisions:Int
    
    private var _bets:[String:Double]
    
    private var _player:Player
    
    var sensitivity:Double {
        return _sensitivity
    }
    
    var betMultiplier:Double {
        return _betMultiplier
    }
    
    var oddsMultiplier:Double {
        return _oddsMultiplier
    }
    
    var ratio:Double {
        return _ratio
    }
    
    var rollCount:Int {
        return _rollCount
    }
    
    var sevenCount:Int {
        return _sevenCount
    }
    
    var bets:[String:Double]? {
        return _bets
    }
    
    var player:Player? {
        return _player
    }
    
    init(sensitivity:Double, betMultiplier:Double, oddsMultiplier:Double, minRollsToMakeDecisions:Int){
        _sensitivity = sensitivity
        _betMultiplier = betMultiplier
        _oddsMultiplier = oddsMultiplier
        _minRollsToMakeDecisions = minRollsToMakeDecisions
        _sevenCount = 0
        _rollCount = 0
    }
    
    func setRatioAndReact(player:Player, rollVal:Int) {
        
        _player = player
        
        _rollCount += 1
        
        if (rollVal == 7) {
            _sevenCount += 1
        }

        _ratio = (Double(_sevenCount) / Double(_rollCount)) / (6/36)
        
        if (rollCount >= _minRollsToMakeDecisions) {
            think()
        }

    }
    
    func think() {
        
        var scale:Double = 1
        let minBet:Double = _player.minBet
        let minSmallBet:Double = _player.minSmallBet
        
        var passLine:Bool = true
        
        if (_player.bets["pass line"] == 0) {
            passLine = false
        }
        
        _bets = _player.bets
        
        switch true {
            
        case (_ratio<(1/_sensitivity)):
            //bet heavier against the table
            
            scale = 1/_ratio*_betMultiplier
            
            _bets=["pass line": _player.bets["pass line"],
                  "pass line odds": 0,
                  "come": 0,
                  "come odds": 0,
                  "don't pass": passLine ? 0: scale * minBet,
                  "don't pass odds": passLine ? 0: scale * minBet * _oddsMultiplier,
                  "don't come": scale * minBet,
                  "don't come odds": scale * minBet * _oddsMultiplier,
                  "craps": 0,
                  "eleven": 0,
                  "seven":0,
                  "hard ways 4": 0,
                  "hard ways 6": 0,
                  "hard ways 8": 0,
                  "hard ways 10": 0,
                  "buy 4": 0,
                  "buy 5": 0,
                  "buy 6": 0,
                  "buy 8": 0,
                  "buy 9": 0,
                  "buy 10": 0]
            
            break
        case ((ratio >= (1/_sensitivity)) && (ratio <= _sensitivity)):
            //bet normally with the table.
            
            _bets=["pass line": passLine ? minBet : 0,
                   "pass line odds": passLine ? minBet : 0,
                   "come": 0,
                   "come odds": 0,
                   "don't pass": passLine ? 0 : scale * minBet,
                   "don't pass odds": 0,
                   "don't come": 0,
                   "don't come odds": 0,
                   "craps": minSmallBet,
                   "eleven": 0,
                   "seven": 0,
                   "hard ways 4": minSmallBet,
                   "hard ways 6": minSmallBet,
                   "hard ways 8": minSmallBet,
                   "hard ways 10": minSmallBet,
                   "buy 4": 0,
                   "buy 5": 0,
                   "buy 6": 0,
                   "buy 8": 0,
                   "buy 9": 0,
                   "buy 10": 0]
            
            break
            
        case (ratio > _sensitivity):
            //bet heavier with the table.
            
            scale = _ratio*_betMultiplier
            
            _bets=["pass line": passLine ? scale * minBet : 0,
                   "pass line odds": passLine ? scale * minBet * _oddsMultiplier : 0,
                   "come": scale * minBet,
                   "come odds": scale * minBet * _oddsMultiplier,
                   "don't pass": passLine ? 0 : _player.bets["don't pass"],
                   "don't pass odds": 0,
                   "don't come": scale * minBet,
                   "don't come odds": scale*minBet * _oddsMultiplier,
                   "craps": 0,
                   "seven": 0,
                   "eleven": 0,
                   "hard ways 4": minSmallBet,
                   "hard ways 6": minSmallBet,
                   "hard ways 8": minSmallBet,
                   "hard ways 10": minSmallBet,
                   "buy 4": 0,
                   "buy 5": 0,
                   "buy 6": 0,
                   "buy 8": 0,
                   "buy 9": 0,
                   "buy 10": 0]
            
            break
            
        default:
            break
            
        }
        
    }
    
}
