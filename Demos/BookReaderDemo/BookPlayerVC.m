//
//  BookPlayerVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "BookPlayerVC.h"


#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>



@interface BookPlayerVC ()

@property int currentPage;
@property int totalPages;
@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation BookPlayerVC

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
    self.totalPages = 20;
    
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
    if (self.currentPage >= self.totalPages) {
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
    if (self.currentPage < 1 || self.currentPage > 20) {
        return;
    }
    
    [self playPageAtIndex:self.currentPage];
    [self showPageAtIndex:self.currentPage];
}

- (void) showPageAtIndex:(int) pageIndex {
    NSString* imageFilePath = [NSString stringWithFormat:@"%@/img-Z14160447-%@.jpg",
    [[NSBundle mainBundle] resourcePath],
    [self intToString:pageIndex]];
    self.pageImageView.image = [UIImage imageWithContentsOfFile:imageFilePath];
}

- (void) playPageAtIndex:(int) pageIndex {
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@.mp3",
                               [[NSBundle mainBundle] resourcePath],
                               [self intToString:pageIndex]];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    self.player = newPlayer;
    //[self.player prepareToPlay];
    
    [self.player play];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
