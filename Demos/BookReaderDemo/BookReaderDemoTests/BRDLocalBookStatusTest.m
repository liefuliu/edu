//
//  BRDLocalBookStatusTest.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 5/1/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BRDLocalBookStatus.h"

@interface BRDLocalBookStatusTest : XCTestCase

@end

@implementation BRDLocalBookStatusTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testEncoding {
    /*
    BRDLocalBookStatus* bookStatus = [[BRDLocalBookStatus alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss Z"];

    bookStatus.lastReadDate = [dateFormatter dateFromString: @"2012-09-16 23:59:59 JST"];
    bookStatus.pageLastRead = 10;
    
    NSCoder* coder = [[NSCoder alloc] init];
    [bookStatus encodeWithCoder:coder];
    
    BRDLocalBookStatus* bookStatusDecoded = [[BRDLocalBookStatus alloc] initWithCoder:coder];
    XCTAssert(bookStatusDecoded.lastReadDate == bookStatus.lastReadDate);
    XCTAssert(bookStatusDecoded.pageLastRead == bookStatus.pageLastRead);
     */
}

@end
