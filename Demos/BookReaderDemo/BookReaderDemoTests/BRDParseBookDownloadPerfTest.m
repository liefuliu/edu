//
//  BRDParseBookDownloadPerfTest.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/8/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BRDBookDownloader.h"

@interface BRDParseBookDownloadPerfTest : XCTestCase

@end

@implementation BRDParseBookDownloadPerfTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    CFTimeInterval startTime = CACurrentMediaTime();
    
    [self measureBlock:^{
        
        // Put the code you want to measure the time of here.
        NSURL* pathUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                       inDomains:NSUserDomainMask] lastObject];
        NSString* path = [[pathUrl path]stringByAppendingPathComponent:@"temp3/"];
        [[BRDBookDownloader sharedObject] downloadBook:@"captaincat"
                toDirectory:path
                                          withMaxLimit: 10];
    }];

    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"Total Runtime: %g s", endTime - startTime);
    
}

@end
