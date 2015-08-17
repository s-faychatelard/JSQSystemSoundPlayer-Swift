//
//  AppDelegate.swift
//  JSQSystemSoundPlayerTest-OSX
//
//  Created by Mélanie Carpin on 17/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Cocoa
import JSQSystemSoundPlayer

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var soundCheckbox: NSButton!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    
    @IBAction func playSystemSoundPressed(sender: NSButton) {
        
        JSQSystemSoundPlayer.sharedPlayer().playSound("Basso", fileExtension: JSQSystemSoundPlayer.TypeAIF) { () -> Void in
            
            println("Sound finished playing. Executing completion block...")
        }
    }
    
    @IBAction func playAlertSoundPressed(sender: NSButton) {
        
        JSQSystemSoundPlayer.sharedPlayer().playAlertSound("Funk", fileExtension: JSQSystemSoundPlayer.TypeAIFF, completion: nil)
        
    }
    
    @IBAction func playLongSoundPressed(sender: NSButton) {
        
        println("Playing long sound...")
        JSQSystemSoundPlayer.sharedPlayer().playSound("BalladPiano", fileExtension: JSQSystemSoundPlayer.TypeCAF) { () -> Void in
            
            println("Long sound complete!")
        }
    }
    
    @IBAction func stopPressed(sender: NSButton) {
        
        JSQSystemSoundPlayer.sharedPlayer().stopAllSounds()
        
        // Stop playing specific sound
        // JSQSystemSoundPlayer.sharedPlayer().stopSound("BalladPiano")
    }
    
    @IBAction func toggleSwitch(sender: NSButton) {
        
        JSQSystemSoundPlayer.sharedPlayer().toggleSoundPlayerOn(sender.state == NSOnState)
    }
}

