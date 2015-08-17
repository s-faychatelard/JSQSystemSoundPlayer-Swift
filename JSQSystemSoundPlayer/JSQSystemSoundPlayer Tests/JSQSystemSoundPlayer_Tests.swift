//
//  JSQSystemSoundPlayer_Tests.swift
//  JSQSystemSoundPlayer Tests
//
//  Created by Mélanie Carpin on 17/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

import UIKit
import XCTest

class JSQSystemSoundPlayer_Tests: XCTestCase {
    
    let soundBasso = "Basso"
    let soundFunk = "Funk"
    let soundBalladPiano = "BalladPiano"
    
    var sharedPlayer: JSQSystemSoundPlayer! = JSQSystemSoundPlayer.sharedPlayer()
    
    override func setUp() {
        super.setUp()
        
        self.sharedPlayer = JSQSystemSoundPlayer.sharedPlayer()
        self.sharedPlayer.bundle = NSBundle(forClass: self.dynamicType)
        self.sharedPlayer.toggleSoundPlayerOn(true)
    }
    
    override func tearDown() {
        self.sharedPlayer.stopAllSounds()
        self.sharedPlayer = nil
        
        super.tearDown()
    }
    
    func testInitAndSharedInstance() {
        
        XCTAssertNotNil(self.sharedPlayer, "Player should not be nil")
        
        let anotherPlayer = JSQSystemSoundPlayer.sharedPlayer()
        XCTAssertEqual(self.sharedPlayer, anotherPlayer, "Players returned from shared instance should be equal")
        
        XCTAssertTrue(self.sharedPlayer.sounds.count == 0, "Sounds dictionary count should be 0")
        XCTAssertTrue(self.sharedPlayer.completionBlocks.count == 0, "Completion blocks dictionary count should be 0")
    }
    
    func testAddingSounds() {
        
        self.sharedPlayer.addSoundIDForAudioFile(self.soundBasso, fileExtension: JSQSystemSoundPlayer.TypeAIF)
        XCTAssertTrue(self.sharedPlayer.sounds.count == 1, "Player should contain 1 cached sound")
        
        let retrievedSoundID: SystemSoundID! = self.sharedPlayer.soundID(forFilename: self.soundBasso)
        XCTAssertTrue(retrievedSoundID != nil, "Retrieved SystemSoundID should not be nil")
        
        let retrievedSoundData: NSData! = self.sharedPlayer.data(soundID: retrievedSoundID)
        XCTAssertNotNil(retrievedSoundData, "Sound data should not be nil")
        
        let soundData: NSData! = self.sharedPlayer.sounds[self.soundBasso]
        XCTAssertNotNil(retrievedSoundData, "Sound data from player sounds list should not be nil")
        
        XCTAssertEqual(retrievedSoundData, soundData, "Sound data should be equal")
        
        self.sharedPlayer.addSoundIDForAudioFile(self.soundBasso, fileExtension: JSQSystemSoundPlayer.TypeAIF)
        XCTAssertTrue(self.sharedPlayer.sounds.count == 1, "Player should still contain 1 only cached sound")
    }
    
    func testAddingSoundsError() {
        
        self.sharedPlayer.addSoundIDForAudioFile("does not exist", fileExtension: JSQSystemSoundPlayer.TypeAIF)
        XCTAssertTrue(self.sharedPlayer.sounds.count == 0, "Player should not contain any cached sounds")
    }
    
    func testCompletionBlocks() {
        
        let soundID: SystemSoundID! = self.sharedPlayer.createSoundID(self.soundBasso, fileExtension: JSQSystemSoundPlayer.TypeAIF)
        let data: NSData! = self.sharedPlayer.data(soundID: soundID)
        
        let completion: JSQSystemSoundPlayerCompletionBlock = {

            println("Completion block")
        }
        
        self.sharedPlayer.addCompletionBlock(completion, toSoundID: soundID)
        XCTAssertTrue(self.sharedPlayer.completionBlocks.count == 1, "Player should contain 1 cached completion blocks")
        
        var retrievedCompletion: JSQSystemSoundPlayerCompletionBlock! = self.sharedPlayer.completionBlocks[data]
        //XCTAssertEqual(completion, retrievedCompletion, "Blocks should be equal")
        
        retrievedCompletion = self.sharedPlayer.completionBlockForSoundID(soundID)
        //XCTAssertEqual(completion, retrievedCompletion, "Blocks should be equal")
        
        self.sharedPlayer.removeCompletionBlockForSoundID(soundID)
        XCTAssertTrue(self.sharedPlayer.completionBlocks.count == 0, "Player should contain 0 cached completion blocks")
        XCTAssertTrue(self.sharedPlayer.completionBlocks[data] == nil, "Blocks should be nil")
        XCTAssertTrue(self.sharedPlayer.completionBlockForSoundID(soundID) == nil, "Blocks should be nil")
    }
    
    func testCreatingAndRetrievingSounds() {
        
        let soundID: SystemSoundID! = self.sharedPlayer.createSoundID(self.soundBasso, fileExtension: JSQSystemSoundPlayer.TypeAIF)
        XCTAssertTrue(soundID != nil, "SoundID should not be nil")
        
        self.sharedPlayer.addSoundIDForAudioFile(self.soundBasso, fileExtension: JSQSystemSoundPlayer.TypeAIF)
        let retrievedSoundID: SystemSoundID! = self.sharedPlayer.soundID(forFilename: self.soundBasso)
        XCTAssertTrue(retrievedSoundID != nil, "Retrieved SystemSoundID should not be nil")
        
        let retrievedSoundData: NSData! = self.sharedPlayer.data(soundID: retrievedSoundID)
        XCTAssertNotNil(retrievedSoundData, "Sound data should not be nil")
        
        let soundIDFromData: SystemSoundID! = self.sharedPlayer.soundID(forData: retrievedSoundData)
        XCTAssertTrue(soundID != nil, "SoundID from data should not be nil")
        XCTAssertEqual(soundIDFromData, retrievedSoundID, "SoundIDs should be equal")
        
        let nilSound: SystemSoundID? = self.sharedPlayer.createSoundID("", fileExtension: "")
        XCTAssert(nilSound == nil, "SoundID should be nil")
        
        let retrievedNilSoundID = self.sharedPlayer.soundID(forFilename: "")
        XCTAssert(retrievedNilSoundID == nil, "SoundID should be nil")
    }
    
    func testPlayingSounds() {
        
        XCTAssert(false, "Playing sound test not yet implemented")
        /*XCTAssertNoThrow([self.sharedPlayer playSoundWithFilename:kSoundBasso
            fileExtension:kJSQSystemSoundTypeAIF
            completion:^{
            NSLog(@"Completion block...");
            }],
        @"Player should play sound and not throw");
        
        XCTAssertNoThrow([self.sharedPlayer playSoundWithFilename:kSoundFunk
        fileExtension:kJSQSystemSoundTypeAIFF
        completion:nil],
        @"Player should play sound and not throw");
        
        XCTAssertNoThrow([self.sharedPlayer playAlertSoundWithFilename:kSoundBasso
        fileExtension:kJSQSystemSoundTypeAIF
        completion:nil],
        @"Player should play alert and not throw");
        
        XCTAssertNoThrow([self.sharedPlayer playAlertSoundWithFilename:kSoundFunk
        fileExtension:kJSQSystemSoundTypeAIFF
        completion:nil],
        @"Player should play alert and not throw with nil block");
        
        XCTAssertNoThrow([self.sharedPlayer playAlertSoundWithFilename:kSoundBalladPiano
        fileExtension:kJSQSystemSoundTypeAIFF
        completion:nil],
        @"Player should fail gracefully and not throw on incorrect extension");
        
        XCTAssertNoThrow([self.sharedPlayer playVibrateSound], @"Player should vibrate and not throw");*/
    }
    
    func testStoppingSounds() {

        self.sharedPlayer.playSound(self.soundBasso, fileExtension: JSQSystemSoundPlayer.TypeAIF, completion: nil)
        self.sharedPlayer.playSound(self.soundBalladPiano, fileExtension: JSQSystemSoundPlayer.TypeCAF, completion: nil)
        
        XCTAssertTrue(self.sharedPlayer.sounds.count == 2, "Player should have 2 sounds cached")
        
        self.sharedPlayer.stopSound(self.soundBalladPiano)
        XCTAssertTrue(self.sharedPlayer.sounds.count == 1, "Player should have 1 sound cached")
    }
    
    func testSoundCompletionBlocks() {
        
        self.sharedPlayer.toggleSoundPlayerOn(true)
        
        let expectation: XCTestExpectation = self.expectationWithDescription(__FUNCTION__)
        
        self.sharedPlayer.playSound(self.soundBasso, fileExtension: JSQSystemSoundPlayer.TypeAIF) { () -> Void in
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10, handler: { (error) -> Void in
            
            XCTAssertNil(error, "Expectation should not error")
        })
    }
    
    func testMemoryWarning() {

        self.sharedPlayer.playSound(self.soundBasso, fileExtension: JSQSystemSoundPlayer.TypeAIF) { () -> Void in
            
            println("Completion block")
        }
        
        XCTAssertTrue(self.sharedPlayer.completionBlocks.count == 1, "Completion blocks dictionary should contain 1 object")
        
        self.sharedPlayer.playAlertSound(self.soundFunk, fileExtension: JSQSystemSoundPlayer.TypeAIFF, completion: nil)
        
        XCTAssertTrue(self.sharedPlayer.sounds.count == 2, "Sounds dictionary should contain 2 objects")
        
        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        
        XCTAssertTrue(self.sharedPlayer.sounds.count == 0, "Sounds should have been purged on memory warning")
        XCTAssertTrue(self.sharedPlayer.completionBlocks.count == 0, "Completion blocks should have been purged on memory warning")
    }
    
    func testUserDefaultsSettings() {
        
        var soundPlayerOn: Bool = self.sharedPlayer.on
        var soundSetting: Bool = NSUserDefaults.standardUserDefaults().objectForKey(JSQSystemSoundPlayer.UserDefaultsKey)!.boolValue
        XCTAssertEqual(soundPlayerOn, soundSetting, "Sound setting values should be equal")
        
        self.sharedPlayer.toggleSoundPlayerOn(false)
        soundPlayerOn = self.sharedPlayer.on
        soundSetting = NSUserDefaults.standardUserDefaults().objectForKey(JSQSystemSoundPlayer.UserDefaultsKey)!.boolValue
        XCTAssertEqual(soundPlayerOn, soundSetting, "Sound setting values should be equal")
        
        self.sharedPlayer.toggleSoundPlayerOn(true)
        soundPlayerOn = self.sharedPlayer.on
        soundSetting = NSUserDefaults.standardUserDefaults().objectForKey(JSQSystemSoundPlayer.UserDefaultsKey)!.boolValue
        XCTAssertEqual(soundPlayerOn, soundSetting, "Sound setting values should be equal")
    }

    func testPreloadSounds() {
        
        XCTAssertTrue(self.sharedPlayer.sounds.count == 0, "Player should begin with no sounds")
        
        self.sharedPlayer.preloadSound(self.soundBasso, fileExtension: JSQSystemSoundPlayer.TypeAIF)
        
        XCTAssertTrue(self.sharedPlayer.sounds.count == 1, "Player should have 1 sound after preloading")
        XCTAssert(self.sharedPlayer.soundID(forFilename: self.soundBasso) != nil, "Player soundID for file should not be 0")
    }
    
    func testPlayingInvalidSoundfileError() {
        
        XCTAssert(false, "Playing sound test not yet implemented")
        /*XCTAssertNoThrow([self.sharedPlayer playSoundWithFilename:@"Does not exist"
        fileExtension:kJSQSystemSoundTypeAIFF
        completion:nil],
        @"Player should play sound and not throw");*/
    }
    
    func testPlayingSoundWhenPlayerIsOff() {
        
        XCTAssert(false, "Playing sound test not yet implemented")
        /*[self.sharedPlayer toggleSoundPlayerOn:NO];
        XCTAssertNoThrow([self.sharedPlayer playSoundWithFilename:kSoundFunk
            fileExtension:kJSQSystemSoundTypeAIFF
            completion:nil],
        @"Player should ignore playing sound and not throw");*/
    }
}
