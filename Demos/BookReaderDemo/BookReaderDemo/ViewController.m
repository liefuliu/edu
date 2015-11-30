//
//  ViewController.m
//
//  Created by Liefu Liu on 11/28/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "ViewController.h"

@import AVFoundation;


#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface ViewController () {

NSMutableDictionary* recordSetting;
}

@property int currentPage;
@property int totalPage;
@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.btnRecord setHidden:YES];
    [self.btnNext setHidden:YES];
    _totalPage = 13;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)play:(id)sender {
    [self reStart];
    [self playPageAtIndex: _currentPage];
}
- (IBAction)next:(id)sender {
    ++_currentPage;
    [self playPageAtIndex: _currentPage];
}
- (IBAction)record:(id)sender {
}


- (void) startRecording{
     
}

- (void) playPageAtIndex:(int) pageIndex {
    if (_currentPage + 1 < _totalPage) {
        [self.btnNext setTitle:[NSString stringWithFormat:@"Next (%d / %d)", _currentPage+1, _totalPage] forState:UIControlStateNormal];
    } else {
        
        [self.btnNext setEnabled:NO];
        self.btnNext.backgroundColor = [UIColor lightGrayColor];
        [self.btnNext setTitle:@"Last Page" forState:UIControlStateDisabled];
    }
    
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/MySound.%d.caf",
                              //DOCUMENTS_FOLDER,
                              [[NSBundle mainBundle] resourcePath],
                               pageIndex];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    self.player = newPlayer;
    //[self.player prepareToPlay];
    
    [self.player play];
}

- (void) legacyplayPageAtIndex:(int) pageIndex {
    NSString*
        recorderFilePath = [NSString stringWithFormat:@"%@/MySound.%d.caf",
                            DOCUMENTS_FOLDER,
                            pageIndex];
    
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


- (void) reStart {
    _currentPage = 0;
    
    [self.btnNext setHidden:NO];
    [self.btnNext setEnabled:YES];
    self.btnNext.backgroundColor = [UIColor grayColor];
    [self.btnPlay setTitle:@"Restart" forState:UIControlStateNormal];
    
}
@end
