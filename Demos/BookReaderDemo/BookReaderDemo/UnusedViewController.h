//
//  ViewController.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 11/28/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface UnusedViewController : UIViewController<AVAudioRecorderDelegate> {
    
    SystemSoundID soundID;

}

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@end

