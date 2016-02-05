//
//  BRDLocalStoreTests.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/30/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BRDConstants.h"
#import "BRDBookShuff.h"

@interface BRDBookShuffTests : XCTestCase

@end

@implementation BRDBookShuffTests

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

- (void)testBasic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:kDownloadedBookKeyString];
    
    NSString* kBookName1 = @"RandomBookName1";
    NSString* kBookName2 = @"RandomBookName2";
    XCTAssert(![[BRDBookShuff sharedObject] doesBookExist:kBookName1]);
    XCTAssert(![[BRDBookShuff sharedObject] doesBookExist:kBookName2]);
    
    [[BRDBookShuff sharedObject] addBook:kBookName1];
    
    XCTAssert([[BRDBookShuff sharedObject] doesBookExist:kBookName1]);
    XCTAssert(![[BRDBookShuff sharedObject] doesBookExist:kBookName2]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
