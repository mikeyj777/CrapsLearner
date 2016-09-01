//
//  CrapsEngine.swift
//  CrapsLearner
//
//  Created by macuser on 8/31/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import Foundation


class CrapsEngine {
    
    private var _dice = [Int](count:2, repeatedValue:0)
    
    private var _onOff:Bool = false
    
    private var _comeOnOff:Bool = false
    
    private var _rollVal:Int = 0
    
    private var _point:Int = 0
    
    private var _comePoint:Int = 0
    
    private var _outcomes = [String:Double]()
    
    init() {
        
    }
    
    func diceRoll() {
        _dice[0] = Int(arc4random_uniform(6)+1)
        _dice[1] = Int(arc4random_uniform(6)+1)
        
        _rollVal = 0
        
        for diceVal in _dice {
            _rollVal += diceVal
        }
        
    }
    
    func consequences() {
        _outcomes = BettingOptions().bets
        
        diceRoll()
        if _onOff {
            
            _point = 0
            
        } else {
            
            //table is off
            
            setOneTimeBetsToNegOne()
            
            
            switch _rollVal {
            case 7:
                _outcomes["seven"] = 1
                _outcomes["pass line"] = 1
                _outcomes["come"] =  1
                _outcomes["don't come"] = -1
                _outcomes["don't pass"] = -1
                break
            case 11:
                _outcomes["eleven"] = 1
                _outcomes["pass line"] = 1
                _outcomes["come"] =  1
                _outcomes["don't come"] = -1
                _outcomes["don't pass"] = -1
                break
            case 2,3, 12:
                _outcomes["craps"] = 1
                _outcomes["pass line"] = -1
                _outcomes["come"] =  -1
                if _rollVal != 12 {
                    _outcomes["don't come"] = 1
                    _outcomes["don't pass"] = 1
                }
            case 4,5,6,8,9,10:
                _onOff = true
                _point = _rollVal
                break
                /*
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
                */
            default:
                break
            }
            
        }
        
    }
    
    func setOneTimeBetsToNegOne() {
        
        _outcomes["craps"] = -1
        _outcomes["seven"] = -1
        _outcomes["eleven"] = -1
        
        
    }
}