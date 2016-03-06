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
#import "BRDConstants.h"
#import "BookPlayerScrollVC.h"
#import "BookPagePlayerVC.h"
#import "BRDFileUtil.h"
#import "BRDPathUtil.h"
#import "BRDBookShuff.h"
#import "BRDBookDownloader.h"

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

@interface BookPlayerScrollVC ()

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property LocalBook* localBookInfo;
@property NSString* localBookKey;
@property NSArray* translatedText;
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

@property BOOL viewIsDismissed;

@property UIActivityIndicatorView *spinner;

@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;

@end

#pragma mark -

@implementation BookPlayerScrollVC

static const float kVerticalScale = 1.0;


- (id) initWithBookKey:(NSString*) localBookKey {
    if (self = [super init]) {
        self.localBookKey = localBookKey;
        self.localBookInfo = [[BRDBookShuff sharedObject] getBook:self.localBookKey];
        if ([self.localBookInfo hasTranslatedText]) {
            self.translatedText = [BRDFileUtil extractTranslatedText:self.localBookKey];
        } else {
            self.translatedText = @[];
        }
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    
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
    
    self.viewIsDismissed = NO;
    [self.view addGestureRecognizer:self.lpgr];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(160, 240);
    _spinner.tag = 12;
    [self.view addSubview:_spinner];
    
    // 如果App是首次运行，则在初始化页面之前，显示操作提示。否则，直接显示初始化页面。
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kNSDefaultsFirstPageLoad])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNSDefaultsFirstPageLoad];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"操作提示", nil)
                                                        message:@"向左滑动往后翻页, 向右滑动往前翻页, 长按屏幕返回主书单。"
                                                       delegate:self
                                              cancelButtonTitle:@"好的，知道了"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self InitializeFromCurrentPage:YES];
    }
    
    if (self.localBookInfo.downloadedPages < self.localBookInfo.totalPages) {
        [self downloadBookTillTopNPages];
    }
    
}


// 在点击"好的，知道了“以后，初始化页面。
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self InitializeFromCurrentPage:YES];
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            LocalBookStatus* localBookStatus = [[BRDBookShuff sharedObject]getBookStatus:self.localBookKey];
            
            // When pagination goes too fast, the current page can be more than the total downloaded pages.
            localBookStatus.pageLastRead = MIN(self.currentPage, self.localBookInfo.downloadedPages - 1);
            
            [[BRDBookShuff sharedObject] updateBookStatus:localBookStatus forKey:self.localBookKey];
            [self dismissViewControllerAnimated:YES completion:nil];
            self.viewIsDismissed = YES;
            return;
        }
    }
}

- (void) downloadBookTillTopNPages {
    NSLog(@"downloadBookTillTopNPages began. self.viewIsDismissed = %d", self.viewIsDismissed);
    if (self.viewIsDismissed) {
        return;
    }
    
    if (self.localBookInfo.downloadedPages >= self.localBookInfo.totalPages) {
        return;
    }
    
    int lastPageToDownload = MIN(self.localBookInfo.downloadedPages  + kNumPagesNonFirstDownload, self.localBookInfo.totalPages);
    
    [[BRDBookDownloader sharedObject] downloadBook:self.localBookKey
                                         startPage:self.localBookInfo.downloadedPages + 1
                                           endPage:lastPageToDownload + 1
                                 withProgressBlock:^(BOOL finished, NSError *error, float percent) {
        if (finished) {
            if (error != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
                                                                message:@"无法下载更多的绘本页面，请检查网络。"
                                                               delegate:self
                                                      cancelButtonTitle:@"好的，知道了"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                NSLog(@"Download till page %d", lastPageToDownload);
                self.localBookInfo.downloadedPages = lastPageToDownload;
                
                [[BRDBookShuff sharedObject] updateBook:self.localBookInfo forKey:self.localBookKey];
                
                if ([_spinner isAnimating]) {
                    [_spinner stopAnimating];
                    [self InitializeFromCurrentPage:YES];
                }
                
                [self downloadBookTillTopNPages];
            }
        }
    }];
    
}

- (void) InitializeFromCurrentPage:(BOOL) pageHasChanged {
    for (UIView *view in self.scrollView1.subviews) {
        [view removeFromSuperview];
    }
    
    NSUInteger numPages = MIN(self.localBookInfo.downloadedPages + 1, self.localBookInfo.totalPages);
    
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
    for (NSUInteger i = 0; i < numPages; i++) {
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
    if (page >= [self.viewControllers count]) {
        return;
    }
    
    // replace the placeholder if necessary
    BookPagePlayerVC *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[BookPagePlayerVC alloc] initWithBookKey:self.localBookKey withPage:(int)page withTranslatedText:self.translatedText];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView1.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        NSLog(@"Page = %lu, frame.x = %f", page, frame.origin.x);
        
        [self addChildViewController:controller];
        [self.scrollView1 addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
        //NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        [controller showPageAtIndex:(int)page];
    }
}

- (void) detatchPage:(NSUInteger) page {
    BookPagePlayerVC *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller != [NSNull null]) {
        [controller willMoveToParentViewController:nil];  // containment call before removing child
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];      // containment call to remove child
    }
    controller = nil;
}


- (void)removeChildController:(UIViewController *)controller
{
    [controller willMoveToParentViewController:nil];  // containment call before removing child
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];      // containment call to remove child
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
        if (page == self.localBookInfo.downloadedPages -1 && self.scrollToLeft) {
            [self alertForLastPage];
            return;
        }
        
        /* 向上滑动的操作已经失效。
         if (scrollView.contentOffset.y > 0) {
         [self dismissViewControllerAnimated:YES completion:nil];
         return;
         }*/
    } else {
        int totalPages = self.localBookInfo.totalPages;
        int downloadedPages = self.localBookInfo.downloadedPages;
        
        self.currentPage = page;
        NSLog(@"current page: %d", page);

        if (self.viewControllers.count == totalPages) {
            // DO nothing
        } else if (self.currentPage + 1 == self.viewControllers.count ) {
            if (self.viewControllers.count <= downloadedPages) {
                [self InitializeFromCurrentPage:NO];
            } else {
                // Waiting for more pages to download
                [_spinner startAnimating];
                if (kDelayDownloadTillEndofPreview) {
                    [self downloadBookTillTopNPages];
                }
                return;
            }
        }

        [self gotoPage:YES];
    }
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL) pageHasChanged
{
    NSInteger page = self.currentPage;
    
    if (pageHasChanged) {
        [_spinner stopAnimating];
    }
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    if (page > 0) {
        [self loadScrollViewWithPage:page - 1];
    }
    
    [self loadScrollViewWithPage:page];
    
    if (page + 1 < self.localBookInfo.downloadedPages) {
        [self loadScrollViewWithPage:page + 1];
    }
    
    // 将第(page - 2)页和(page + 2) 页从Scroll View移除。这样可以内存溢出。
    for (int p = MAX(0, page - 2);
         p <= MIN(page + 2, self.viewControllers.count - 1); ++p)
    {
        BookPagePlayerVC *controller = [self.viewControllers objectAtIndex:p];
        if ((NSNull *)controller != [NSNull null]) {
            if (controller.page < (page - 1) ||
                controller.page > (page + 1))
            {
                [self removeChildController:controller];
                self.viewControllers[p] = [NSNull null];
            }
        }
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
                               [BRDPathUtil applicationDocumentsDirectoryPath],
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示"
                                                    message:@"已经翻到最后一页。向左滑动往后翻页, 向右滑动往前翻页, 长按屏幕返回。"
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) alertForFirstPage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示"
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
