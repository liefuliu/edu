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

// Please remove the app before running the test.
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    CFTimeInterval startTime = CACurrentMediaTime();
    NSString *UUID = [[NSUUID UUID] UUIDString];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [BRDParseBookDownloadPerfTest cleanUpPFFileCacheDirectory];
    [self measureBlock:^{
        
        // Put the code you want to measure the time of here.
        NSURL* pathUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                       inDomains:NSUserDomainMask] lastObject];
        NSString* path = [[pathUrl path]stringByAppendingPathComponent:UUID];
        
         dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[BRDBookDownloader sharedObject] downloadBook:@"captaincat"
                toDirectory: path
                forTopNPages: 100
         withProgressBlock:^(BOOL finished, NSError *error, float percent) {
             if (finished) {
                 dispatch_semaphore_signal(semaphore);
             }
             
         }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }];

    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"Total Runtime: %g s", endTime - startTime);
    
}


+ (void)cleanUpPFFileCacheDirectory
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cacheDirectoryURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *PFFileCacheDirectoryURL = [cacheDirectoryURL URLByAppendingPathComponent:@"Parse/PFFileCache" isDirectory:YES];
    NSArray *PFFileCacheDirectory = [fileManager contentsOfDirectoryAtURL:PFFileCacheDirectoryURL includingPropertiesForKeys:nil options:0 error:&error];
    
    if (!PFFileCacheDirectory || error) {
        if (error && error.code != NSFileReadNoSuchFileError) {
            NSLog(@"Error : Retrieving content of directory at URL %@ failed with error : %@", PFFileCacheDirectoryURL, error);
        }
        return;
    }
    
    for (NSURL *fileURL in PFFileCacheDirectory) {
        BOOL success = [fileManager removeItemAtURL:fileURL error:&error];
        if (!success || error) {
            NSLog(@"Error : Removing item at URL %@ failed with error : %@", fileURL, error);
            error = nil;
        }
    }
}

@end
