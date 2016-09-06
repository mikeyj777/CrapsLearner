//
//  ViewController.swift
//  CrapsLearner
//
//  Created by macuser on 8/31/16.
//  Copyright © 2016 ResponseApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var txtPlayers: UITextField!
    
    @IBOutlet var txtBankroll: UITextField!
    
    @IBOutlet var txtMinBet: UITextField!

    @IBOutlet var txtMinSmallBet: UITextField!
    
    @IBOutlet var sliderSensitivity: UISlider!

    @IBAction func btnGo(sender: AnyObject) {
        
        let bankroll:Double = Double(txtBankroll.text!)!

        /*
         
        let numPlayers:Int = Int(txtPlayers.text!)!
        
        let minBet:Double = Double(txtMinBet.text!)!
        
        let minSmallBet:Double = Double(txtMinSmallBet.text!)!
        
        let sensitivity:Double = Double(sliderSensitivity.value)
        
        */
        
        var sensVary:Double = 0.01
        
        var gc:GameControl
        
        var handsPlayedArray:[Double]
        
        while (sensVary <= 1000) {
            
            var minBetVary = 0.001 * bankroll
            while (minBetVary <= bankroll) {
                
                var minSmallBetVary = 0.0001 * bankroll
                var count = 0
                while (minSmallBetVary <= bankroll) {
                    count += 1
                    handsPlayedArray = [Double]()
                    
                    gc = GameControl(numPlayers: 1, bankroll: bankroll, minBet: minBetVary, minSmallBet: minSmallBetVary, sensitivity: sensVary)
                    
                    gc.playCraps()
                    
                    if gc.learnings.count > 100 {
                        for learning in gc.learnings {
                            
                            handsPlayedArray.append(learning["hands played"]!)
                            
                        }
                        
                        let statCalcs = StatCalcs()
                        
                        let mMean:Double = statCalcs.arrMean(handsPlayedArray)
                        
                        let sSdev:Double = statCalcs.stndDev(handsPlayedArray)
                        
                        let passingRatio:Double =  sSdev / mMean
                        
                        if (passingRatio < 0.01) {
                            
                            minSmallBetVary += 0.0001 * bankroll
                            
                        }

                    }
                    
                    
                    
                    
                }
                minBetVary += 0.001 * bankroll
            }
            
            sensVary += 0.01
        }
        
    }
    
    
    
    
}

