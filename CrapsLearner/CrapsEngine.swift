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
    
    private var _dontPassOnOff:Bool = false
    
    private var _comeOnOff:Bool = false
    
    private var _dontComeOnOff:Bool = false
    
    private var _makeComeBet:Bool = false
    
    private var _makeDontComeBet:Bool = false
    
    private var _rollVal:Int = 0
    
    private var _point:Int = 0
    
    private var _comePoints = [Int]()
    
    private var _dontComePoints = [Int]()
    
    private var _outcomes = [String:Double]()
    
    var makeComeBet:Bool {
        return _makeComeBet
    }
    
    var makeDontComeBet:Bool {
        return _makeDontComeBet
    }
    
    init() {
        
    }
    
    func playerMakesComeBet(setVal:Bool) {
        _makeComeBet = setVal
    }
    
    func playerMakesDontComeBet(setVal:Bool) {
        _makeDontComeBet = setVal
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
        
        checkHardWaysAndBuys()
        
        setOneTimeBetsToNegOne()
        
        switch _rollVal {
        case 7:
            _outcomes["pass line"] = _onOff ? -1.0 : 1.0
            _outcomes["don't pass"] = _onOff ? 1.0 : -1.0
            
            _outcomes["come"] = _onOff ? -1.0 : 1.0
            _outcomes["don't come"] = _onOff ? 1.0 : -1.0
            
            switch _rollVal {
            case 4,10:
                _outcomes["dont come odds"] = 1/2
                _outcomes["dont pass odds"] = 1/2
                break
            case 5,9:
                _outcomes["dont come odds"] = 2/3
                _outcomes["dont pass odds"] = 2/3
                break
            case 6,8:
                _outcomes["dont come odds"] = 5/6
                _outcomes["dont pass odds"] = 5/6
                break
            default:
                break
                
            }
            
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
            break
        case 4,5,6,7,8,9,10:
            
            for (key, bet) in _outcomes {
                
                if ((key.rangeOfString("pass") != nil) || (key.rangeOfString("come") != nil)) {
                    if ((key.rangeOfString("come") != nil) &&
                        (_comePoints.count != 0)) {
                        
                        for point in _comePoints {
                            checkAgainstPossiblePoint(point, key)
                        }
                            
                    } else {
                        if (_point > 0) {
                            checkAgainstPossiblePoint(_point, key)
                        } else {
                            if (_rollVal != 7) {
                                _point = _rollVal
                                _onOff = true
                            }
                        }
                        
                        
                    }
                        
                }
            }
            
            if (_rollVal == 7) {
                otherSevenActivities()
            }
            
            break
            
//            if (_dontComeOnOff) {
//                for (i,num) in _dontComePoints.enumerate().reverse() {
//                    if (num == _rollVal) {
//                        _dontComePoints.removeAtIndex(i)
//                        if (_dontComePoints.count == 0) {
//                            _dontComeOnOff = false
//                        }
//                        _outcomes["dont come"] = -1
//                        _outcomes["dont come odds"] = -1
//                        
//                    }
//                }
//            }
        
            
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
        
        if _comeOnOff {
            
        } else {
            
        }
        
    }
    
    func checkAgainstPossiblePoint(point: Int, key:String) {
        
        if ((_rollVal == 7) || (_rollVal == point)) {
            if (key.rangeOfString("don't") != nil) {
                _outcomes[key] = _rollVal == 7 ? 1 : -1
            } else {
                _outcomes[key] = _rollVal == 7 ? -1 : 1
            }
            
            var multiplier:Double = 1
            
            switch _rollVal {
            case 4,10:
                multiplier = 2
                break
            case 5,9:
                multiplier = 1.5
                break
            case 6,8:
                multiplier = 1.2
                break
            default:
                break
            }
            
            if (key.rangeOfString("don't") != nil) {
                multiplier = 1/multiplier
            }
            
            if (_outcomes[key] > 0) {
                _outcomes[key] *= multiplier
            }
            
        }

        if (key.rangeOfString("come") != nil) {
            if (key.rangeOfString("don't'") != nil) {

            }
        }
        
    }
    
    func otherSevenActivities() {
        _onOff = false
        
        _dontPassOnOff = false
        
        _comeOnOff = false
        
        _dontComeOnOff = false
        
        _outcomes["seven"] = 1
    }
    
    func setOneTimeBetsToNegOne() {
        
        _outcomes["craps"] = -1
        _outcomes["seven"] = -1
        _outcomes["eleven"] = -1
 
    }
    
    func checkHardWaysAndBuys() {
        

        
    }
    
}