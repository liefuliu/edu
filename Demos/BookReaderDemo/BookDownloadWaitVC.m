//
//  BookDownloadWaitVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/24/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BookDownloadWaitVC.h"
#import "CircularProgressView.h"
#import "BRDPathUtil.h"
#import <Parse/Parse.h>

@interface BookDownloadWaitVC ()


@end

@implementation BookDownloadWaitVC

CircularProgressView* m_testView;
NSTimer* m_timer;
NSString* _bookKey;

- (id) initWithBookKey: (NSString*) bookKey {
    self = [super init];
    if (self) {
        _bookKey = bookKey;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    m_testView = [[CircularProgressView alloc] initWithFrame:self.view.bounds];
    m_testView.percent = 100;
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        PFQuery *query = [PFQuery queryWithClassName:@"BookImage"];
        
        // 可以考虑在此查看该书是否已经下载，根据_boo
        [query whereKey:@"bookName" equalTo:_bookKey];
     
        NSArray* objects = [query findObjects];
        NSLog(@"Successfully retrieved %d scores.", objects.count);
     
        if (objects != nil) {
        NSMutableArray* bookList = [[NSMutableArray alloc] init];
        int totalBooks = MIN(1000, [objects count]);
        int downloaded = 0;
       for (PFObject *object in objects) {
          PFFile* pageContent = (PFFile*) object[@"pageContent"];
          NSLog(@"bookName: %@", [pageContent name]);
          NSString* documentPath = [BRDPathUtil convertToDocumentPath:(NSString*)[pageContent name]];
           
          [BookDownloadWaitVC downloadParseFile:pageContent to:documentPath];
          NSLog(@"local document path: %@", documentPath);
          
          ++downloaded;
          __block int percent = downloaded * 100 / totalBooks;
          
          //we get the main thread because drawing must be done in the main thread always
          dispatch_async(dispatch_get_main_queue(),^ {
             [self updateStatus:percent];
          });
           
          if (downloaded == totalBooks) {
              dispatch_async(dispatch_get_main_queue(),^ {
                  [self dismissViewControllerAnimated:YES completion:nil];
                  [self.delegate downloadComplete:_bookKey];
              });
              break;
          }
        }
       }
     });
}

- (void) updateStatus:(int) percent {
    if (percent < 100) {
        m_testView.percent = percent;
        [m_testView setNeedsDisplay];
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
