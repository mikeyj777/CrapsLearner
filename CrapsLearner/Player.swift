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
    
    private var _dontComePoints = [Int]()
    
    private var _comePoints = [Int]()
    
    private var _handsPlayed = 0
    
    private var _rowForLearning = [String:Double]()
    
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
    
    var dontComePoints:[Int] {
        return _dontComePoints
    }
    
    var comePoints:[Int] {
        return _comePoints
    }
    
    var handsPlayed:Int {
        return _handsPlayed
    }
    
    var rowForLearning:[String:Double] {
        return _rowForLearning
    }
    
    func addComePoint(point:Int) {
        var pointExists:Bool = false
        for comePoint in _comePoints {
            if (comePoint == point) {
                pointExists = true
            }
        }
        
        if !pointExists {
            _comePoints.append(point)
        }
    }
    
    func addDontComePoint(point:Int) {
        
        var pointExists:Bool = false
        for dontComePoint in _dontComePoints {
            if (dontComePoint == point) {
                pointExists = true
            }
        }
        
        if !pointExists {
            _dontComePoints.append(point)
        }
        
    }
    
    func clearComePoints() {
        _comePoints.removeAll()
    }
    
    func clearDontComePoints() {
        _dontComePoints.removeAll()
    }
    
    func clearComePoint(point:Int) {
        
        for (i,num) in _comePoints.enumerate().reverse() {
            if (point==num) {
                _comePoints.removeAtIndex(i)
            }
        }
        
    }
    
    func clearDontComePoint(point:Int) {
        
        for (i,num) in _dontComePoints.enumerate().reverse() {
            if (point==num) {
                _dontComePoints.removeAtIndex(i)
            }
        }
        
    }
    
    init(bankroll: Double, minBet: Double, minSmallBet: Double, sensitivity: Double) {
        _bankroll = bankroll
        _minBet = minBet
        _minSmallBet = minSmallBet
        
        _rowForLearning = ["min bet ratio":minBet/bankroll,
                           "min small bet ratio":minSmallBet/bankroll,
                           "sensitivity": sensitivity,
                           "hands played": 0]
        
        _bets = BettingOptions().bets
        
        setInitialBets()
    }
    
    func setInitialBets() {
        
        _bets["pass line"] =  _minBet
        _bets["craps"] = _minSmallBet
        
    }
    
    func payouts(outcomes:[String:Double]) {
        
        _handsPlayed += 1
        
        _rowForLearning["hands played"] = Double(_handsPlayed)
        
        for (key,value) in outcomes {
            
            _bankroll += _bets[key]! * value
            if (_bankroll <= 0) {
                _bankroll = 0
                break
            }
        }
        
    }
    
}
