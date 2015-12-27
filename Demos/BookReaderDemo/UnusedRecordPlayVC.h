//
//  RecordPlayVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 11/28/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface UnusedRecordPlayVC : UIViewController <AVAudioRecorderDelegate>
{
    
    __weak IBOutlet UIProgressView *progressView;
    
    __weak IBOutlet UILabel *lblStatusMsg;
    NSMutableDictionary *recordSetting;
    NSMutableDictionary *editedObject;
    NSString *recorderFilePath;
    AVAudioRecorder *recorder;
    
    SystemSoundID soundID;
    NSTimer *timer;
    
}

@end
