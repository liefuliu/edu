//
//  RecordVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 11/29/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RecordVC : UIViewController <AVAudioRecorderDelegate>
{
    NSMutableDictionary *recordSetting;
    NSMutableDictionary *editedObject;
    NSString *recorderFilePath;
    AVAudioRecorder *recorder;
    
    SystemSoundID soundID;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnNextPage;
@property (weak, nonatomic) IBOutlet UILabel *labelRecording;

@property int totalPages;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@end
