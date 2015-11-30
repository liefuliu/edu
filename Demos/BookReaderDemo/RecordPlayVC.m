//
//  RecordPlayVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 11/28/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "RecordPlayVC.h"


#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@interface RecordPlayVC ()

@end

@implementation RecordPlayVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblStatusMsg.text = @"Stopped";
    progressView.progress = 0.0;
}

- (void) handleTimer
{
    progressView.progress += .07;
    if(progressView.progress == 1.0)
    {
        [timer invalidate];
        lblStatusMsg.text = @"Stopped";
    }
}

- (IBAction) startRecording
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    recordSetting = [[NSMutableDictionary alloc] init];
    
    // We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    
    // We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
    [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
    
    // We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    // These settings are used if we are using kAudioFormatLinearPCM format
    //[recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    //[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    
    
    // Create a new dated file
    //NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    //	NSString *caldate = [now description];
    //	recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
    recorderFilePath = [NSString stringWithFormat:@"%@/MySound.caf", DOCUMENTS_FOLDER] ;
    
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
    
    // start recording
    [recorder recordForDuration:(NSTimeInterval) 20];
    
    lblStatusMsg.text = @"Recording...";
    progressView.progress = 0.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}

- (IBAction) stopRecording
{
    [recorder stop];
    
    [timer invalidate];
    lblStatusMsg.text = @"Stopped";
    progressView.progress = 1.0;
    
    //NSURL *url = [NSURL fileURLWithPath: recorderFilePath];
    //	NSError *err = nil;
    //	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    //	if(!audioData)
    //        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    //	[editedObject setValue:[NSData dataWithContentsOfURL:url] forKey:@"editedFieldKey"];
    //
    //	//[recorder deleteRecording];
    //
    //
    //	NSFileManager *fm = [NSFileManager defaultManager];
    //
    //	err = nil;
    //	[fm removeItemAtPath:[url path] error:&err];
    //	if(err)
    //        NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    
    
}

- (IBAction)playSound
{
    if(!recorderFilePath)
        recorderFilePath = [NSString stringWithFormat:@"%@/MySound.caf", DOCUMENTS_FOLDER];
    
    //NSLog(@"Playing sound from Path: %@",recorderFilePath);
    
    if(soundID)
    {
        AudioServicesDisposeSystemSoundID(soundID);
    }
    
    
    //Get a URL for the sound file
    NSURL *filePath = [NSURL fileURLWithPath:recorderFilePath isDirectory:NO];
    
    //Use audio sevices to create the sound
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    AudioServicesPlaySystemSound(soundID);
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    [timer invalidate];
    lblStatusMsg.text = @"Stopped";
    progressView.progress = 1.0;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end
