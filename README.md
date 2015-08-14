# JSQSystemSoundPlayer in Swift

A fancy Swift wrapper for Cocoa [System Sound Services](https://developer.apple.com/library/ios/documentation/AudioToolbox/Reference/SystemSoundServicesReference/Reference/reference.html), for iOS.

This class is a light-weight, drop-in component to play sound effects, or other short sounds in your iOS app. 
To determine your audio needs, see [Best Practices for iOS Audio](https://developer.apple.com/library/ios/DOCUMENTATION/AudioVideo/Conceptual/MultimediaPG/UsingAudio/UsingAudio.html#//apple_ref/doc/uid/TP40009767-CH2-SW10).
Or, read the tl;dr version:

>*When your sole audio need is to play alerts and user-interface sound effects, use Core Audio’s System Sound Services.*
>
>Your sound files must be:
>
>* No longer than 30 seconds in duration
>* In linear PCM or IMA4 (IMA/ADPCM) format
>* Packaged in a `.caf`, `.aif`, or `.wav` file

If this does not fit your needs, then this control is not for you! 
See [AVAudioPlayer](https://developer.apple.com/library/ios/DOCUMENTATION/AVFoundation/Reference/AVAudioPlayerClassReference/Reference/Reference.html), instead.

![screenshot ios][imgLinkiOS]

## Features

* Play sound effects and alert sounds with a single line of code
* "Play" vibration (if available on device)
* Block-based completion handlers
* Integration with `NSUserDefaults` to globally toggle sound effects in your app
* Sweet and efficient memory management
* Caches sounds (`SystemSoundID` instances) and purges on memory warning
* Works with Swift! (v1.2)

## Installation

````bash
github "s-faychatelard/JSQSystemSoundPlayer-Swift"
````

### Manually

1. Add the `JSQSystemSoundPlayer.framework` folder to the embedded framework project

## Getting Started

````objective-c
#import <JSQSystemSoundPlayer/JSQSystemSoundPlayer.h>
// or
@import JSQSystemSoundPlayer;
````

#### Playing sounds

````objective-c
[[JSQSystemSoundPlayer sharedPlayer] playSoundWithFilename:@"mySoundFile"
                                             fileExtension:JSQSystemSoundPlayer.TypeAIF
                                                completion:^{
                                                   // completion block code
                                                }];
````
````swift
JSQSystemSoundPlayer.sharedPlayer().playAlertSound("mySoundFile", fileExtension: JSQSystemSoundPlayer.TypeAIFF) { () -> Void in
            
           // completion block code 
        }
````
And that's all! 

String constants for file extensions provided for you: 
* `JSQSystemSoundPlayer.TypeCAF`
* `JSQSystemSoundPlayer.TypeAIF`
* `JSQSystemSoundPlayer.TypeAIFF`
* `JSQSystemSoundPlayer.TypeWAV`

#### Toggle sounds effects settings on/off

Need a setting in your app's preferences to toggle sound effects on/off? `JSQSystemSoundPlayer` can do that, too! There's no need to ever check the saved settings (`[JSQSystemSoundPlayer sharedPlayer].on`) before you play a sound effect. Just play a sound like in the example above. `JSQSystemSoundPlayer` respects whatever setting has been previously saved.

````objective-c
[[JSQSystemSoundPlayer sharedPlayer] toggleSoundPlayerOn:YES];
````
````swift
JSQSystemSoundPlayer.sharedPlayer().toggleSoundPlayerOn(true)
````

#### Specifying a bundle

Need to load your audio resources from a specific bundle? `JSQSystemSoundPlayer` uses the main bundle by default, but you can specify another. 

**NOTE:** for each sound that is played `JSQSystemSoundPlayer` will **always** search the **last specified bundle**. If you are playing sound effects from multiple bundles, you will need to specify the bundle before playing each sound.

````objective-c
[JSQSystemSoundPlayer sharedPlayer].bundle = [NSBundle mainBundle];
````
````swift
JSQSystemSoundPlayer.sharedPlayer().bundle = NSBundle.mainBundle()
````

#### Demo project

The included example app, `JSQSystemSoundPlayerTest.xcodeproj`, exercises all functionality of this framework. There are applications for iOS. 

#### For a good time

````objective-c
while (1) {
    [[JSQSystemSoundPlayer sharedPlayer] playVibrateSound];
}
````
````swift
JSQSystemSoundPlayer.sharedPlayer().playVibrateSound()
````

## Credits

Created and maintained by [**@Sylvain Fay-Châtelard**](https://twitter.com/proto0moi)
from the awesome JSQSystemSoundPlayer project.

## License

`JSQSystemSoundPlayer-Swift` is released under an [MIT License][mitLink]. See `LICENSE` for details.

>**Copyright &copy; 2015 Jesse Squires, Sylvain FAY-CHATELARD.**

*Please provide attribution, it is greatly appreciated.*

[mitLink]:http://opensource.org/licenses/MIT
[imgLinkiOS]:https://raw.githubusercontent.com/jessesquires/JSQSystemSoundPlayer/develop/screenshot-ios.png
