//
//  BookDownloadWaitVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/24/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//
#import "BRDConstants.h"
#import "BookDownloadWaitVC.h"
#import "CircularProgressView.h"
#import "BRDPathUtil.h"
#import "BookPlayerScrollVC.h"
#import "BRDBookDownloader.h"
#import <Parse/Parse.h>

@interface BookDownloadWaitVC ()


@end

@implementation BookDownloadWaitVC

CircularProgressView* m_testView;
NSTimer* m_timer;
NSString* _bookKey;

const float progressSubViewRatio = 0.6;

- (id) initWithBookKey: (NSString*) bookKey {
    self = [super init];
    if (self) {
        _bookKey = bookKey;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect subViewFrame;
    subViewFrame.size.height = [[UIScreen mainScreen] bounds].size.height * progressSubViewRatio;
    subViewFrame.size.width = [[UIScreen mainScreen] bounds].size.width * progressSubViewRatio;
    
    // Do any additional setup after loading the view, typically from a nib.
    m_testView = [[CircularProgressView alloc] initWithFrame:subViewFrame];
    m_testView.percent = 1;
    
    m_testView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width  / 2,
                                     [[UIScreen mainScreen] bounds].size.height / 2);
    NSLog(@"half width = %f, height = %f", [[UIScreen mainScreen] bounds].size.width  / 2, [[UIScreen mainScreen] bounds].size.height / 2);

    [self.view addSubview:m_testView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    // Kick off a timer to count it down
    // m_timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(decrementSpin) userInfo:nil repeats:YES];
    [self downloadBooks];
}

+ (void) downloadParseFile:(PFFile*) parseFile
                        to:(NSString*) documentPath {
    NSData* webData = [parseFile getData];
    [webData writeToFile:documentPath atomically:YES];
}


- (void) downloadBooks {
    [[BRDBookDownloader sharedObject] downloadBook:_bookKey forTopNPages:kNumPagesFirstDownload withProgressBlock:^(BOOL finished, NSError* error, float percent) {
        if (error != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"该书本不存在" delegate:self cancelButtonTitle:@"好的，知道了" otherButtonTitles:nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else if (finished) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate downloadComplete:_bookKey forTopNPages:kNumPagesFirstDownload];
        } else {
            [self updateStatus:percent];
        }
    }];
}

- (void) updateStatus:(int) percent {
    if (percent < 100) {
        while (m_testView.percent < percent) {
            m_testView.percent++;
            // m_testView.percent = percent;
            if (m_testView.percent % 5 == 0) {
                [m_testView setNeedsDisplay];
            }
        }
    } else {
        [m_testView setHidden:YES];
    }
}

- (void)decrementSpin
{
    // If we can decrement our percentage, do so, and redraw the view
    if (m_testView.percent > 0) {
        m_testView.percent = m_testView.percent - 1;
        [m_testView setNeedsDisplay];
    }
    else {
        [m_timer invalidate];
        m_timer = nil;
        [m_testView setHidden:YES];
    }
}

@end
