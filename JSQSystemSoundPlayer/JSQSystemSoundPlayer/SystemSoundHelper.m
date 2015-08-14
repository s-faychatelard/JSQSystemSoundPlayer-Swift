//
//  SystemSoundHelper.m
//  JSQSystemSoundPlayer
//
//  Created by Sylvain FAY-CHATELARD on 13/08/2015.
//  Copyright (c) 2015 Dviance. All rights reserved.
//

#import "SystemSoundHelper.h"

@implementation SystemSoundHelper

static SystemSoundHelper *_sharedInstance;

void audioServicesSystemSoundCompletionProc(SystemSoundID soundID, void* clientData) {

    _sharedInstance.completion(soundID);
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (AudioServicesSystemSoundCompletionProc)completionHandler {

    return audioServicesSystemSoundCompletionProc;
}


@end
