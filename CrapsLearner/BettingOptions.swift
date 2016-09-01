//
//  BettingOptions.swift
//  CrapsLearner
//
//  Created by macuser on 8/31/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import Foundation

class BettingOptions {
    
    private var _bets:[String:Double]
    
    var bets:[String:Double] {
        return _bets
    }
    
    init(){
        
        _bets=["pass line": 0,
               "pass line odds": 0,
               "come": 0,
               "come odds": 0,
               "don't pass": 0,
               "don't pass odds": 0,
               "don't come": 0,
               "don't come odds": 0,
               "craps": 0,
               "eleven": 0,
               "seven": 0,
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
        
    }
    
    
}