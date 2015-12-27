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

@property (nonatomic, retain) AVAudioPlayer *player;

@property CGFloat xDragStart;
@property CGFloat yDragStart;

@end

#pragma mark -

@implementation RootViewController

static const float kVerticalScale = 1.1;

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
    
    NSUInteger numberPages = self.localBookInfo.totalPages;
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // a page is the width of the scroll view
    self.scrollView1.pagingEnabled = YES;
    self.scrollView1.contentSize =
        CGSizeMake(CGRectGetWidth(self.scrollView1.frame) * numberPages, CGRectGetHeight(self.scrollView1.frame) * kVerticalScale);
    
    self.scrollView1.showsHorizontalScrollIndicator = NO;
    self.scrollView1.showsVerticalScrollIndicator = NO;
    self.scrollView1.scrollsToTop = NO;
    self.scrollView1.delegate = self;
    
    self.pageControl1.numberOfPages = numberPages;
    self.pageControl1.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    
    // [self loadScrollViewWithPage:-1];
    /*
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
     */
     [self gotoPage:NO]; // remain at the same page (don't animate)
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // remove all the subviews from our scrollview
    
    for (UIView *view in self.scrollView1.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger numPages = self.localBookInfo.totalPages;
    
    // adjust the contentSize (larger or smaller) depending on the orientation
    self.scrollView1.contentSize =
        CGSizeMake(CGRectGetWidth(self.scrollView1.frame) * numPages, CGRectGetHeight(self.scrollView1.frame) * kVerticalScale);
    
    // clear out and reload our pages
    self.viewControllers = nil;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    /*
    [self loadScrollViewWithPage:self.pageControl1.currentPage - 1];
    [self loadScrollViewWithPage:self.pageControl1.currentPage];
    [self loadScrollViewWithPage:self.pageControl1.currentPage + 1];*/
    [self gotoPage:NO]; // remain at the same page (don't animate)
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

        [self addChildViewController:controller];
        [self.scrollView1 addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
        //NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        [controller showPageAtIndex:(int)page];
    }
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView1.frame);
    
    NSUInteger page = floor((self.scrollView1.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (self.pageControl1.currentPage == page) {
        if (scrollView.contentOffset.y > 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
    } else {
        self.pageControl1.currentPage = page;
    
        /*
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        if (page > 0) {
            [self loadScrollViewWithPage:page - 1];
        }
        
        [self loadScrollViewWithPage:page];
        
        if (page < self.localBookInfo.totalPages) {
            [self loadScrollViewWithPage:page + 1];
        }
          */
        
        [self gotoPage:YES];
    }
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL) pageHasChanged
{
    NSInteger page = self.pageControl1.currentPage;

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    /*
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
     */
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    if (page > 0) {
        [self loadScrollViewWithPage:page - 1];
    }
    
    [self loadScrollViewWithPage:page];
    
    if (page < self.localBookInfo.totalPages) {
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
    //[self.player prepareToPlay];
    
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



- (IBAction)changePage:(id)sender
{
    // [self gotoPage:YES];    // YES = animate
}

@end
