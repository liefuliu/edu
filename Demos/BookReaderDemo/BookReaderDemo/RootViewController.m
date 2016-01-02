/*
     File: RootViewController.m
 Abstract: The primary root view controller for the iPhone.
  Version: 1.6
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 */

#import "RootViewController.h"
#import "BookPlayerVC.h"

#import "LocalBookStore.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
/*
static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";
*/

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface RootViewController ()

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property LocalBook* localBookInfo;
@property NSString* localBookKey;
@property int currentPage;

@property (nonatomic, retain) AVAudioPlayer *player;

@property CGFloat xDragStart;
@property CGFloat yDragStart;

@property
CGFloat lastContentOffset;

// 最近一次滑动是否向右。
@property BOOL scrollToRight;

// 最近一次滑动是否向左。
@property BOOL scrollToLeft;


@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;

@end

#pragma mark -

@implementation RootViewController

static const float kVerticalScale = 1.0;

// 有几个问题待解决
// - 第0页没有声音，第1也没有动画效果
// - 已经翻到最后一页的提示。
// - 动画不要上下浮动
// - 第一次进入，加操作提示。

- (id) initWithBookKey:(NSString*) localBookKey {
    if (self = [super init]) {
        self.localBookKey = localBookKey;
        self.localBookInfo = [[LocalBookStore sharedObject] getBookWithKey:self.localBookKey];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // a page is the width of the scroll view
    self.scrollView1.pagingEnabled = YES;
    
    self.scrollView1.showsHorizontalScrollIndicator = NO;
    self.scrollView1.showsVerticalScrollIndicator = NO;
    self.scrollView1.scrollsToTop = NO;
    self.scrollView1.delegate = self;
    
    _currentPage = 0;
    
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 50.0f;
    
    [self.view addGestureRecognizer:self.lpgr];
    
    [self InitializeFromCurrentPage:YES];
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
    }
}

- (void) InitializeFromCurrentPage:(BOOL) pageHasChanged {
    for (UIView *view in self.scrollView1.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger numPages = self.localBookInfo.totalPages;
    
    // 将ScrollView的高宽设置为与屏幕一致。
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect scrollFrame;
    scrollFrame.origin = self.scrollView1.frame.origin;
    scrollFrame.size = screenRect.size;
    self.scrollView1.frame = scrollFrame;
    
    // ScrollView的总宽为（宽度x页数）。
    self.scrollView1.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView1.frame) * numPages, CGRectGetHeight(self.scrollView1.frame));
    
    // clear out and reload our pages
    self.viewControllers = nil;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    [self gotoPage:pageHasChanged]; // remain at the same page (don't animate)
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // remove all the subviews from our scrollview
    [self InitializeFromCurrentPage:NO];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.localBookInfo.totalPages)
        return;
    
    if (page == 1) {
        NSLog(@"page == 1");
    }
    
    // replace the placeholder if necessary
    BookPlayerVC *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[BookPlayerVC alloc] initWithBookKey:self.localBookKey];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView1.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        NSLog(@"Page = %d, frame.x = %f", page, frame.origin.x);

        [self addChildViewController:controller];
        [self.scrollView1 addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
        //NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        [controller showPageAtIndex:(int)page];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.x) {
        self.scrollToLeft = true;
        self.scrollToRight = false;
    } else if (self.lastContentOffset < scrollView.contentOffset.x) {
        self.scrollToLeft = false;
        self.scrollToRight = true;
    }
    self.lastContentOffset = scrollView.contentOffset.x;
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView1.frame);
    
    NSUInteger page = floor((self.scrollView1.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    NSLog(@"self.scrollView1.contentOffset.x = %f", self.scrollView1.contentOffset.x);
    NSLog(@"page = %d, pageWidth = %f", page, pageWidth);
    
    if (self.currentPage == page) {
        // 如果在首页向右滑动，则显示首页提示。
        if (page == 0 && self.scrollToRight) {
            [self alertForFirstPage];
            return;
        }
        
        // 如果在末页向左滑动，则显示末页提示。
        if (page == self.localBookInfo.totalPages -1 && self.scrollToLeft) {
            [self alertForLastPage];
            return;
        }
        
        /* 向上滑动的操作已经失效。
        if (scrollView.contentOffset.y > 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
          }*/
    } else {
        self.currentPage = page;
        NSLog(@"current page: %d", page);
        [self gotoPage:YES];
    }
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL) pageHasChanged
{
    NSInteger page = self.currentPage;

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    if (page > 0) {
        [self loadScrollViewWithPage:page - 1];
        
    }
    [self loadScrollViewWithPage:page];

    if (page + 1 < self.localBookInfo.totalPages) {
       [self loadScrollViewWithPage:page + 1];
    }

    // update the scroll view to the appropriate page
    CGRect bounds = self.scrollView1.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView1 scrollRectToVisible:bounds animated:pageHasChanged];
    
    if (pageHasChanged) {
        [self playPageAtIndex:page];
    }
}

- (void) playPageAtIndex:(int) pageIndex {
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@-audio-%@.mp3",
                               [[NSBundle mainBundle] resourcePath],
                               self.localBookInfo.filePrefix,
                               [self intToString:pageIndex+1]];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    self.player = newPlayer;
    [self.player play];
}

// 移植到公共函数区
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

- (void) alertForLastPage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"友情提示", nil)
                                                    message:@"已经翻到最后一页。向左滑动往后翻页, 向右滑动往前翻页, 长按屏幕返回。"
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) alertForFirstPage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"友情提示", nil)
                                                    message:@"已经翻到第一页。 向左滑动往后翻页, 向右滑动往前翻页, 长按屏幕返回。"
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil];
    
    [alert show];

}

- (IBAction)changePage:(id)sender
{
    // [self gotoPage:YES];    // YES = animate
}

@end
