//
//  ViewController.swift
//  JSQSystemSoundPlayerTest
//
//  Created by Mélanie Carpin on 14/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit
import JSQSystemSoundPlayer

class ViewController: UIViewController {
    
    @IBOutlet var soundSwitch: UISwitch!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.soundSwitch.on = JSQSystemSoundPlayer.sharedPlayer.on
    }

    @IBAction func playSystemSoundPressed(sender: UIButton) {
        
        JSQSystemSoundPlayer.sharedPlayer.playSound("Basso", fileExtension: JSQSystemSoundPlayer.TypeAIF) { () -> Void in
            
            print("Sound finished playing. Executing completion block...")
        }
    }
    
    @IBAction func playAlertSoundPressed(sender: UIButton) {
        
        JSQSystemSoundPlayer.sharedPlayer.playAlertSound("Funk", fileExtension: JSQSystemSoundPlayer.TypeAIFF, completion: nil)
        
    }
    
    @IBAction func playVibratePressed(sender: UIButton) {
        
        JSQSystemSoundPlayer.sharedPlayer.playVibrateSound()
    }
    
    @IBAction func playLongSoundPressed(sender: UIButton) {
        
        print("Playing long sound...")
        JSQSystemSoundPlayer.sharedPlayer.playSound("BalladPiano", fileExtension: JSQSystemSoundPlayer.TypeCAF) { () -> Void in
            
            print("Long sound complete!")
        }
    }
    
    @IBAction func stopPressed(sender: UIButton) {
        
        JSQSystemSoundPlayer.sharedPlayer.stopAllSounds()

        // Stop playing specific sound
        // JSQSystemSoundPlayer.sharedPlayer().stopSound("BalladPiano")
    }
    
    @IBAction func toggleSwitch(sender: UISwitch) {
        
        JSQSystemSoundPlayer.sharedPlayer.toggleSoundPlayerOn(sender.on)
    }
}

