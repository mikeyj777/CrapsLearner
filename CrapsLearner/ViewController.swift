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
        
        let numPlayers = Int(txtPlayers.text!)!
        
        let bankroll = Double(txtBankroll.text!)!
        
        let minBet:Double = Double(txtMinBet.text!)!
        
        let minSmallBet:Double = Double(txtMinSmallBet.text!)!
        
        let sensitivity:Double = Double(sliderSensitivity.value)
        
        let gc = GameControl(numPlayers: numPlayers, bankroll: bankroll, minBet: minBet, minSmallBet: minSmallBet, sensitivity: sensitivity)
        
        gc.playCraps()
        
    }
}

