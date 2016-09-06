//
//  StatCalcs.swift
//  CrapsLearner
//
//  Created by macuser on 9/6/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import Foundation

class StatCalcs {
    
    private var _mean:Double = 0
    
    func arrMean(array:[Double]) -> Double {
    
        var totVal:Double = 0
        
        for point in array {
            totVal += point
        }
        
        _mean = array.count > 0 ? totVal/Double(array.count) : 0.0
        
        return _mean
    }
    
    func stndDev(array:[Double]) -> Double {
        
        var sse:Double = 0
        
        if (_mean == 0) {
            arrMean(array)
        }
        
        for point in array {
            sse += pow(point-_mean,2)
        }
        
        sse = array.count > 0 ? sqrt(sse) : 0.0
        
        return sse
    }
    
    init () {
        
    }
    
}