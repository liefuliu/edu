//
//  BookPlayerVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "BookPlayerVC.h"
#import "LocalBook.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LocalBookStore.h"

@interface BookPlayerVC ()

/*
@property int totalPages;
@property NSArray* translatedText;
*/

@property int currentPage;
@property LocalBook* localBookInfo;
@property NSString* localBookKey;

@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation BookPlayerVC

- (id) initWithBookKey:(NSString*) localBookKey {
    if (self = [super init]) {
        self.localBookKey = localBookKey;
        self.localBookInfo = [[LocalBookStore sharedObject] getBookWithKey:self.localBookKey];
    }
    return self;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    UISwipeGestureRecognizer * swipeup=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeup:)];
    swipeup.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeup];
    
    self.currentPage = 1;
    
    [self paginate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) swipeup: (UISwipeGestureRecognizer*) gestureRecognizer {
    NSLog(@"swipeup");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
     NSLog(@"swipeleft");
    [self attemptNextPage];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    NSLog(@"swiperight");
      [self attemptPrevPage];
}


- (void) attemptPrevPage {
    if (self.currentPage <= 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"友情提示", nil)
                                                        message:@"已经翻到第一页。 向左滑动往后翻页, 向右滑动往前翻页, 向上滑动返回。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        --self.currentPage;
        [self paginate];
    }
}

- (void) attemptNextPage {
    if (self.currentPage >= self.localBookInfo.totalPages) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"友情提示", nil)
                                                        message:@"已经翻到最后一页。向左滑动往后翻页, 向右滑动往前翻页, 向上滑动返回。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        ;
        [alert show];
    } else {
        ++self.currentPage;
        [self paginate];
    }
}
      
- (void) paginate {
    if (self.localBookInfo == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
                                                        message:@"该绘本不存在。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    if (self.currentPage < 1 || self.currentPage > 20) {
        return;
    }
    
    [self playPageAtIndex:self.currentPage];
    [self showPageAtIndex:self.currentPage];
}

- (void) showPageAtIndex:(int) pageIndex {
    NSString* imageFilePath = [NSString stringWithFormat:@"%@/%@-picture-%@.jpg",
                               [[NSBundle mainBundle] resourcePath],
                               self.localBookInfo.filePrefix,
                               [self intToString:pageIndex]];
    self.pageImageView.image = [UIImage imageWithContentsOfFile:imageFilePath];
    if (pageIndex < self.localBookInfo.translatedText.count &&
        ((NSString*)self.localBookInfo.translatedText[pageIndex]).length > 0) {
        self.translatedTextView.text = (NSString*)self.localBookInfo.translatedText[pageIndex];
        self.translatedTextView.hidden = NO;
    } else {
        self.translatedTextView.hidden = YES;
    }
}

- (void) playPageAtIndex:(int) pageIndex {
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@-audio-%@.mp3",
                               [[NSBundle mainBundle] resourcePath],
                               self.localBookInfo.filePrefix,
                               [self intToString:pageIndex]];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    self.player = newPlayer;
    //[self.player prepareToPlay];
    
    [self.player play];
}
 
 */
- (NSString*) intToString:(int) integer {
    if (integer < 10) {
        return [NSString stringWithFormat:@"000%d", integer];
    } else if (integer < 100) {
        return [NSString stringWithFormat:@"00%d", integer];
    } else if (integer < 1000) {
        return [NSString stringWithFormat:@"0%d", integer];
    } else {
        return [NSString stringWithFormat:@"%d", integer];
    }
}


- (void) showPageAtIndex:(int) pageIndex {
    NSString* imageFilePath = [NSString stringWithFormat:@"%@/%@-picture-%@.jpg",
                               [[NSBundle mainBundle] resourcePath],
                               self.localBookInfo.filePrefix,
                               [self intToString:pageIndex+1]]; // 绘本页从1开始计数。
    self.pageImageView.image = [UIImage imageWithContentsOfFile:imageFilePath];
    if (pageIndex < self.localBookInfo.translatedText.count &&
        ((NSString*)self.localBookInfo.translatedText[pageIndex]).length > 0) {
        self.translatedTextView.text = (NSString*)self.localBookInfo.translatedText[pageIndex];
        self.translatedTextView.hidden = NO;
    } else {
        self.translatedTextView.hidden = YES;
    }
}


@end
