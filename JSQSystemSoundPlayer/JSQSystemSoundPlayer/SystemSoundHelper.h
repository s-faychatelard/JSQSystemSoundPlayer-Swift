//
//  SystemSoundHelper.h
//  JSQSystemSoundPlayer
//
//  Created by Sylvain FAY-CHATELARD on 13/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

@import Foundation;
@import AudioToolbox;

@interface SystemSoundHelper : NSObject

@property (nonatomic, copy) void (^completion)(SystemSoundID soundID);

+ (instancetype)sharedInstance;
- (AudioServicesSystemSoundCompletionProc)completionHandler;

void audioServicesSystemSoundCompletionProc(SystemSoundID soundID, void* clientData);

@end
