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
    
    private var _rollVal:Int = 0
    
    private var _point:Int = 0
    
    private var _comePoints = [Int]()
    
    private var _dontComePoints = [Int]()
    
    private var _outcomes = [String:Double]()
    
    private var _players:[Player]
    
    var rollVal:Int {
        return _rollVal
    }
    
    var outcomes:[String:Double] {
        return _outcomes
    }
    
    init(players:[Player]) {
        _players = players
    }
    
    func diceRoll() {
        _dice[0] = Int(arc4random_uniform(6)+1)
        _dice[1] = Int(arc4random_uniform(6)+1)
        
        _rollVal = 0
        
        for diceVal in _dice {
            _rollVal += diceVal
        }
    }
    
    func consequences() -> [Player]{
        
        _outcomes = BettingOptions().bets
        
        checkHardWaysAndBuys()
        
        setOneTimeBetsToNegOne()
        
        switch _rollVal {

        case 11:
            _outcomes["eleven"] = 1
            _outcomes["pass line"] = _onOff ? 0 : 1
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
            
            for (key, _) in _outcomes {
                
                if ((key.rangeOfString("pass") != nil) || (key.rangeOfString("come") != nil)) {
                    if (key.rangeOfString("come") != nil)  {
                        
                        for player in _players {
                            if (player.comePoints.count != 0) {
                                
                                for point in player.comePoints {
                                    checkAgainstPossiblePoint(player, point:point, key: key)
                                }
                            }
                            
                            if (player.dontComePoints.count != 0) {
                                
                                for point in player.dontComePoints {
                                    checkAgainstPossiblePoint(player, point:point, key: key)
                                }
                            }
                        }
                        
                        
                        
                    } else {
                        if (_point > 0) {
                            let dummyPlayer = Player(bankroll: 0, minBet: 0, minSmallBet: 0)
                            checkAgainstPossiblePoint(dummyPlayer, point: _point, key:key)
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
            
            break
        default:
            break
        }
        
        return _players
    }
    
    func checkAgainstPossiblePoint(player:Player, point: Int, key:String) {
        
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
            
            _outcomes[key]! *= multiplier
            
            if (_rollVal == 7) {
                if (key.rangeOfString("come") != nil) {
                    if (key.rangeOfString("don't") == nil) {
                        player.clearComePoints()
                    } else {
                        player.clearDontComePoints()
                    }
                } else {
                    _point = 0
                    _onOff = false
                }
                
            } else {
                
                if (key.rangeOfString("don't") == nil) {
                    player.clearComePoint(_rollVal)
                } else {
                    player.clearDontComePoint(_rollVal)
                }
                
            }
        }
        

    }
    
    func otherSevenActivities() {
        _onOff = false
        
        _dontPassOnOff = false
        
        _outcomes["seven"] = 1
    }
    
    func setOneTimeBetsToNegOne() {
        
        _outcomes["craps"] = -1
        _outcomes["seven"] = -1
        _outcomes["eleven"] = -1
        
    }
    
    func checkHardWaysAndBuys() {
        
        for i in 4...10 {
            
            if (_rollVal == i) && (_rollVal != 7) {
                
                if (_dice[0] == _dice[1]) {
                    _outcomes["hard ways " + String(i)] = 1
                }
                
                _outcomes["buy " + String(i)] = 1
                
            }
            
            var multiplier:Double = 1
            
            switch _rollVal {
            case 4:
                
                multiplier = 7
                break
            case 6:
                
                multiplier = 9
                break
            case 8:
                
                multiplier = 9
                break
            case 10:
                
                multiplier = 7
                break
            default:
                break
                
            }
            
            _outcomes["hard ways " + String(i)]! *= multiplier
            
        }
        
    }
}