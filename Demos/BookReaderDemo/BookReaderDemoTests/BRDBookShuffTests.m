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
    if ([defaults objectForKey:kDownloadedBookKeyString] != nil) {
        [defaults setObject:nil forKey:kDownloadedBookKeyString];
    }
    
    NSString* kBookName1 = @"RandomBookName1";
    NSString* kBookName2 = @"RandomBookName2";
    XCTAssert(![[BRDBookShuff sharedObject] doesBookExist:kBookName1]);
    XCTAssert(![[BRDBookShuff sharedObject] doesBookExist:kBookName2]);
    
    LocalBook* localBook = [[LocalBook alloc]init];
                            
    [[BRDBookShuff sharedObject] addBook:localBook forKey:kBookName1];
    
    XCTAssert([[BRDBookShuff sharedObject] doesBookExist:kBookName1]);
    XCTAssert(![[BRDBookShuff sharedObject] doesBookExist:kBookName2]);
    
    [[BRDBookShuff sharedObject] deleteBook:kBookName1];
    XCTAssert(![[BRDBookShuff sharedObject] doesBookExist:kBookName1]);
}

- (void) testBookStatus {
    BRDLocalBookStatus* bookStatus = [[BRDLocalBookStatus alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    bookStatus.lastReadDate = [dateFormatter dateFromString: @"2012-09-16 23:59:59 JST"];
    bookStatus.pageLastRead = 10;

    NSString* kBookName1 = @"BRDBookShuffTests_testBookStatus_book1";
    [[BRDBookShuff sharedObject] addBook:[[LocalBook alloc]init] forKey:kBookName1];
    [[BRDBookShuff sharedObject] updateBookStatus:bookStatus forKey:kBookName1];
    
    BRDLocalBookStatus* bookStatusDecoded =
    [[BRDBookShuff sharedObject] getBookStatus:kBookName1];
    XCTAssert(bookStatusDecoded.lastReadDate == bookStatus.lastReadDate);
    XCTAssert(bookStatusDecoded.pageLastRead == bookStatus.pageLastRead);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
