//
//  FilePathUtilTests.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 10/29/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FilePathUtil.h"

@interface FilePathUtilTests : XCTestCase

@end

@implementation FilePathUtilTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void) testGetTypeFile {
    // bad
    XCTAssertEqual([FilePathUtil getFileType:@"a"], kFileTypeUnknown);
    
    // good
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-cover.jpg"], kCover);
    
    // "cover1.jpg" doesn't follow the pattern "cover.jpg": unknown type.
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-cover1.jpg"], kFileTypeUnknown);
    
    // good
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-audio-0001.mp3"], kAudio);
    
    // page number is not 4 digits: unknown type.
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-audio-1.mp3"], kFileTypeUnknown);
    
    // good
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-picture-0001.jpg"], kImage);
    
    // jpeg: unknown type
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-picture-0001.jpeg"], kFileTypeUnknown);
    
    // page number is not 4 digits: unknown type.
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-picture-1.jpg"], kFileTypeUnknown);
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-picture-10.jpg"], kFileTypeUnknown);

    // good.
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-trans.txt"], kTranslation);
    
    // "translation.txt": unknown type.
    XCTAssertEqual([FilePathUtil getFileType:@"mytest-translation.txt"], kFileTypeUnknown);

}



@end
