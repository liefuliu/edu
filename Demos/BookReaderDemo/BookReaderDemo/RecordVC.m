//
//  RecordVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 11/29/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "RecordVC.h"



#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@interface RecordVC ()

@property BOOL recordingStarted;
@property int elapsedTimeInSeconds;

@end

@implementation RecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _elapsedTimeInSeconds = 0;
    
    [self resetButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)startRecording:(id)sender {
    if (_recordingStarted) {
        [self finishPageRecording];
        [self resetButton];
    } else {
        [self startRecordPageAtIndex:_totalPages];
        ++_totalPages;
        _recordingStarted = true;
        [self.btnRecord setTitle:@"结束录音" forState:UIControlStateNormal];
        [self.btnNextPage setHidden:NO];
        [self.labelTime setHidden:NO];
        [self.labelRecording setHidden:NO];
    }
}

- (IBAction)nextPage:(id)sender {
    [self finishPageRecording];
    [self startRecordPageAtIndex:_totalPages];
    ++_totalPages;
}

- (void) resetButton {
    _recordingStarted = false;
    _totalPages = 3;
    [self.btnRecord setTitle:@"开始录音" forState:UIControlStateNormal];
    [self.btnNextPage setHidden:YES];
    [self.labelTime setHidden:YES];
    [self.labelRecording setHidden:YES];
}

- (void) startRecordPageAtIndex: (int) pageIndex {
    _elapsedTimeInSeconds = 0;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    recordSetting = [[NSMutableDictionary alloc] init];
    
    // We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    
    // We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
    [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
    
    // We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    recorderFilePath = [NSString stringWithFormat:@"%@/MySound.%d.caf",DOCUMENTS_FOLDER, pageIndex];
    
    NSLog(@"recorderFilePath: %@",recorderFilePath);
    
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    
    err = nil;
    
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    
    err = nil;
    recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //prepare to record
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }
    
    [self.labelRecording setText:[NSString stringWithFormat:@"%d", pageIndex]];
    
    // start recording
    [recorder recordForDuration:(NSTimeInterval) 60];
    
    //lblStatusMsg.text = @"Recording...";
    //progressView.progress = 0.0;
    _elapsedTimeInSeconds = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}

- (void) finishPageRecording {
    [recorder stop];
    
    [timer invalidate];
}


- (void) handleTimer
{
    /*
    progressView.progress += .07;
    if(progressView.progress == 1.0)
    {
        [timer invalidate];
        lblStatusMsg.text = @"Stopped";
    }*/
    ++_elapsedTimeInSeconds;
    _labelTime.text = [NSString stringWithFormat:@"朗读时间: %d 秒", _elapsedTimeInSeconds];
}

@end
