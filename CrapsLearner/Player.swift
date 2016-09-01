//
//  Player.swift
//  CrapsLearner
//
//  Created by macuser on 8/31/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import Foundation

class Player {
    
    private var _minBet:Double
    
    private var _minSmallBet:Double
    
    private var _bankroll:Double
    
    private var _bets:[String:Double]
    
    //private var _bettingOptions = BettingOptions()
    
    var minBet:Double {
        return _minBet
    }
    
    var bankroll:Double {
        return _bankroll
    }
    
    var bets:[String:Double] {
        return _bets
    }
    
    var minSmallBet:Double {
        return _minSmallBet
    }
    
    init(bankroll: Double, minBet: Double, minSmallBet: Double) {
        _bankroll = bankroll
        _minBet = minBet
        _minSmallBet = minSmallBet
        
        _bets = BettingOptions().bets
        
        setInitialBets()
    }
    
    func setInitialBets() {
        
        _bets["pass line"] =  _minBet
        _bets["craps"] = _minSmallBet
        
    }
    
    func payouts(outcomes:[String:Double]) {
        
        for (key,value) in outcomes {
            
            _bankroll += _bets[key]! * value
            if (_bankroll <= 0) {
                _bankroll = 0
                break
            }
        }
        
    }
    
}
