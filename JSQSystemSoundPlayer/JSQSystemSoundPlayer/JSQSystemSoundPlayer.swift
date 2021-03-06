//
//  JSQSystemSoundPlayer.swift
//  JSQSystemSoundPlayer
//
//  Created by Sylvain FAY-CHATELARD on 13/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import Foundation
import AudioToolbox

#if os(iOS)
    import UIKit
#endif

public typealias JSQSystemSoundPlayerCompletionBlock = (() -> Void)

@objc public class JSQSystemSoundPlayer: NSObject {
    
    static var UserDefaultsKey: String = "kJSQSystemSoundPlayerUserDefaultsKey"
    
    public static let TypeCAF: String = "caf"
    public static let TypeAIF: String = "aif"
    public static let TypeAIFF: String = "aiff"
    public static let TypeWAV: String = "wav"
    
    public var bundle: NSBundle
    private(set) public var on: Bool = false
    
    /* Those parameters are set to private for XCTest access */
    internal var sounds: [String: NSData] = [:]
    internal var completionBlocks: [NSData: JSQSystemSoundPlayerCompletionBlock] = [:]
    
    // MARK: - Init
    
    public static let sharedPlayer: JSQSystemSoundPlayer = JSQSystemSoundPlayer()
    
    override init() {
        
        self.bundle = NSBundle.mainBundle()
        self.on = true
        
        super.init()
        
        #if os(iOS)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceiveMemoryWarningNotification:"), name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        #endif
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.unloadSoundIDs()
    }
    
    // MARK: - Playing sounds
    
    func playSound(filename: String, fileExtension: String, isAlert: Bool, completion: JSQSystemSoundPlayerCompletionBlock?) {
        
        if !self.on {
            
            return
        }
        
        if self.sounds[filename] == nil {
            
            self.addSoundIDForAudioFile(filename, fileExtension: fileExtension)
        }
        
        if let soundID: SystemSoundID = self.soundID(forFilename: filename) {
            
            if let completion = completion {

                let error: OSStatus = AudioServicesAddSystemSoundCompletion(soundID, nil, nil, { (soundID, userData) -> Void in
                    let player = JSQSystemSoundPlayer.sharedPlayer
                    if let block = player.completionBlockForSoundID(soundID) {

                        block()
                        player.removeCompletionBlockForSoundID(soundID)
                    }
                }, nil)
                    
                if error != kAudioServicesNoError {
                    
                    self.logError(error, withMessage: "Warning! Completion block could not be added to SystemSoundID.")
                }
                else {
                    
                    self.addCompletionBlock(completion, toSoundID: soundID)
                }
            }
            
            if isAlert {
                
                AudioServicesPlayAlertSound(soundID)
            }
            else {
                
                AudioServicesPlaySystemSound(soundID)
            }
        }
    }
    
    private func readSoundPlayerOnFromUserDefaults() -> Bool {
        
        if let settings = NSUserDefaults.standardUserDefaults().objectForKey(JSQSystemSoundPlayer.UserDefaultsKey) as? NSNumber {
            
            return settings.boolValue
        }
        
        self.toggleSoundPlayerOn(true)
        
        return true
    }
    
    // MARK: - Public API
    
    @objc public func toggleSoundPlayerOn(on: Bool) {
        
        self.on = on;
        
        NSUserDefaults.standardUserDefaults().setObject(NSNumber(bool: on), forKey: JSQSystemSoundPlayer.UserDefaultsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        if !on {
            self.stopAllSounds()
        }
    }
    
    @objc public func playSound(filename: String, fileExtension: String, completion: JSQSystemSoundPlayerCompletionBlock?) {
        
        self.playSound(filename, fileExtension: fileExtension, isAlert: false, completion: completion)
    }
    
    @objc public func playAlertSound(filename: String, fileExtension: String, completion: JSQSystemSoundPlayerCompletionBlock?) {
        
        self.playSound(filename, fileExtension: fileExtension, isAlert: true, completion: completion)
    }
    
#if os(iOS)
    @objc public func playVibrateSound() {
        
        if self.on {
        
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
#endif
    
    @objc public func stopAllSounds() {
    
        self.unloadSoundIDs()
    }
    
    @objc public func stopSound(filename: String) {
        
        if let soundID = self.soundID(forFilename: filename) {
            
            let data = self.data(soundID: soundID)
            
            self.unloadSoundID(filename)
            self.sounds.removeValueForKey(filename)
            self.completionBlocks.removeValueForKey(data)
        }
    }
    
    @objc public func preloadSound(filename: String, fileExtension: String) {
        
        if let _ = self.sounds[filename] {
            
            return
        }
        
        self.addSoundIDForAudioFile(filename, fileExtension: fileExtension)
    }
    
    // MARK: - Sound data
    
    func data(var soundID  soundID: SystemSoundID) -> NSData {
        
        return NSData(bytes: &soundID, length: sizeof(SystemSoundID))
    }
    
    func soundID(forData data: NSData) -> SystemSoundID? {
     
        var soundID: SystemSoundID = 0
        data.getBytes(&soundID, length: sizeof(SystemSoundID))
        return soundID
    }
    
    // MARK: - Sound files
    
    func soundID(forFilename filename: String) -> SystemSoundID? {
        
        if let data = self.sounds[filename] {
        
            return self.soundID(forData: data)
        }
        return nil
    }
    
    func addSoundIDForAudioFile(filename: String, fileExtension: String) {
    
        if let soundID = self.createSoundID(filename, fileExtension: fileExtension) {
            
            let data = self.data(soundID: soundID)
            self.sounds.updateValue(data, forKey: filename)
        }
    }
    
    // MARK: - Sound completion blocks
    
    func completionBlockForSoundID(soundID: SystemSoundID) -> JSQSystemSoundPlayerCompletionBlock? {
        
        let data = self.data(soundID: soundID)
        return self.completionBlocks[data]
    }
    
    func addCompletionBlock(completion: JSQSystemSoundPlayerCompletionBlock, toSoundID soundID: SystemSoundID) {
        
        let data = self.data(soundID: soundID)
        self.completionBlocks.updateValue(completion, forKey: data)
    }
    
    func removeCompletionBlockForSoundID(soundID: SystemSoundID) {
        
        let key = self.data(soundID: soundID)
        self.completionBlocks.removeValueForKey(key)
        AudioServicesRemoveSystemSoundCompletion(soundID)
    }
    
    // MARK: - Managing sound
    
    func createSoundID(filename: String, fileExtension: String) -> SystemSoundID? {
        
        if let fileURL = self.bundle.URLForResource(filename, withExtension: fileExtension) {
            
            if NSFileManager.defaultManager().fileExistsAtPath(fileURL.path ?? "") {
                
                var soundID: SystemSoundID = 0
                let error: OSStatus = AudioServicesCreateSystemSoundID(fileURL, &soundID)
                if error != kAudioServicesNoError {
                    
                    self.logError(error, withMessage: "Warning! SystemSoundID could not be created.")
                    return nil;
                }
                
                return soundID
            }
            
            print("[\(self)] Error: audio file not found at URL: \(fileURL)")
            return nil
        }
        
        print("[\(self)] Error: audio file not found: \(filename)")
        return nil
    }
    
    func unloadSoundIDs() {
        
        for filename in self.sounds.keys {
            
            self.unloadSoundID(filename)
        }
        
        self.sounds.removeAll()
        self.completionBlocks.removeAll()
    }
    
    func unloadSoundID(filename: String) {
        
        if let soundID = self.soundID(forFilename: filename) {
         
            AudioServicesRemoveSystemSoundCompletion(soundID)
            
            let error: OSStatus = AudioServicesDisposeSystemSoundID(soundID)
            if error != kAudioServicesNoError {
                
                self.logError(error, withMessage: "Warning! SystemSoundID could not be disposed.")
            }
        }
    }
    
    func logError(error: OSStatus, withMessage message: String) {
        
        var errorMessage: String?
        switch error {
        case kAudioServicesUnsupportedPropertyError:
            errorMessage = "The property is not supported."
        case kAudioServicesBadPropertySizeError:
            errorMessage = "The size of the property data was not correct."
        case kAudioServicesBadSpecifierSizeError:
            errorMessage = "The size of the specifier data was not correct."
        case kAudioServicesSystemSoundUnspecifiedError:
            errorMessage = "An unspecified error has occurred."
        case kAudioServicesSystemSoundClientTimedOutError:
            errorMessage = "System sound client message timed out."
        default:
            errorMessage = "Unkown error"
        }
        
        print("[\(self)] \(message) Error: (code \(error)) \(errorMessage)")
    }
    
    // MARK: - Notifications
    
    func didReceiveMemoryWarningNotification(notification: NSNotification) {
        
        self.unloadSoundIDs()
    }
}