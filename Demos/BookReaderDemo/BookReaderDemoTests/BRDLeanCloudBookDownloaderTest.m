//
//  BRDLeanCloudBookDownloaderTest.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 7/3/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDLeanCloudBookDownloader.h"
#import <XCTest/XCTest.h>

@interface BRDLeanCloudBookDownloaderTest : XCTestCase

@property BOOL downloadTestEnabled;

@end

@implementation BRDLeanCloudBookDownloaderTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _downloadTestEnabled = false;
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
    // Please only enable this test when necessary.
    // The test might be expensive. See
    if (self.downloadTestEnabled) {
    
    // This is an example of a performance test case.
    CFTimeInterval startTime = CACurrentMediaTime();
    
    __block int totalAttempts = 0;
    __block int totalDownlaods = 0;
    __block int topNPagesToDownload = 10;
    __block NSURL* pathUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                                     inDomains:NSUserDomainMask] lastObject];
    
    
    [self measureBlock:^{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [BRDLeanCloudBookDownloaderTest cleanUpPFFileCacheDirectory];
    
    __block BOOL downloadComplete = false;
        NSString *UUID = [[NSUUID UUID] UUIDString];

            // Put the code you want to measure the time of here.
        
        NSString* path = [[pathUrl path]stringByAppendingPathComponent:UUID];
        NSLog(@"path = %@", path);
        
        NSFileManager *fileManager= [NSFileManager defaultManager];
        BOOL isDir;
        if(![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
            if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL]) {
                NSLog(@"Error: Create folder failed %@", path);
            }
        }
    
        __block BOOL isCancelled = false;
        [[BRDLeanCloudBookDownloader sharedObject] downloadBook:@"Stanley"
                                                toDirectory: path
                                               forTopNPages: topNPagesToDownload
                                                cancelToken:&isCancelled
                                          withProgressBlock:^(BOOL finished, NSError *error, float percent) {
                                              NSLog(@"percent = %f%%", percent);
                                              if (finished) {
                                                  downloadComplete = true;
                                              }
                                              
                                          }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
    while (!downloadComplete) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate: loopUntil];
        loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
        
        NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        totalDownlaods += [directoryContent count];
        
        totalAttempts += topNPagesToDownload * 2 + 2;
        NSLog(@"Downloaded %d of %d. Successful rate: %.2f", totalDownlaods, totalAttempts, totalDownlaods * 100.0 / totalAttempts);
        
    }];
    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"Total Runtime: %g s", endTime - startTime);
    }

}


+ (void)cleanUpPFFileCacheDirectory
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cacheDirectoryURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *PFFileCacheDirectoryURL = [cacheDirectoryURL URLByAppendingPathComponent:@"AVPaasFiles" isDirectory:YES];
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
