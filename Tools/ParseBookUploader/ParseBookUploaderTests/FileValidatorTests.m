
//
//  FileValidatorTests.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 7/5/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FileValidator.h"

@interface FileValidatorTests : XCTestCase

@end

@implementation FileValidatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoverFileValidatorSuccess {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    const NSString* smallFilePath = @"./mybook-cover.jpg";
    [[NSFileManager defaultManager] createFileAtPath:smallFilePath contents:nil attributes:nil];
    //This creates an empty file, which you can write to or read from. To write text (or XML), just use NSString's writeToFile:atomically:encoding:error: method like this
    
    NSString *str = @"Hello world";
    [str writeToFile:smallFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrayOfFiles = [[NSMutableArray alloc] init];
    [arrayOfFiles addObject:smallFilePath];
    
    NSArray* errors;
    NSArray* warnings;
    XCTAssertTrue([FileValidator validateFiles:arrayOfFiles errorsTo:&errors warningsTo:&warnings]);
    
    [self deleteFile:smallFilePath];
}

- (void)testCoverFileValidatorFailure {
    // Create a small cover file.
    const NSString* smallFilePath = @"./mybook-cover.jpg";
    [[NSFileManager defaultManager] createFileAtPath:smallFilePath contents:nil attributes:nil];
    //This creates an empty file, which you can write to or read from. To write text (or XML), just use NSString's writeToFile:atomically:encoding:error: method like this
    
    NSString *str = @"Hello world";
    [str writeToFile:smallFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrayOfFiles = [[NSMutableArray alloc] init];
    [arrayOfFiles addObject:smallFilePath];
    
    // Create a large cover file.
    const NSString* largeFilePath = @"./largebook-cover.jpg";
    [self createLargeFile:largeFilePath];
    [arrayOfFiles addObject:largeFilePath];
    
    // Verifies the valdation is failed as the one file's size is too big.
    NSArray* errors;
    NSArray* warnings;
    XCTAssertFalse([FileValidator validateFiles:arrayOfFiles errorsTo:&errors warningsTo:&warnings]);
    
    [self deleteFile:smallFilePath];
    [self deleteFile:largeFilePath];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) createLargeFile:(NSString*) filePath {
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    //This creates an empty file, which you can write to or read from. To write text (or XML), just use NSString's writeToFile:atomically:encoding:error: method like this
    
    NSString* content = @"Hello world";
    for (int i = 0; i < 10; i++) {
        content = [content stringByAppendingString:content];
    }
    XCTAssertTrue([content length] > 10 * 1024);
    
    for (int j = 0; j < 100; j++) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        if (fileHandle){
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
        } else {
            [content writeToFile:filePath
                      atomically:NO
                        encoding:NSStringEncodingConversionAllowLossy
                           error:nil];
        }
    }
    
    BOOL isDirNotUsed;
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirNotUsed]);
    NSString* curDir = [[NSFileManager defaultManager] currentDirectoryPath];
    NSLog(@"curDir = %@", curDir);
    
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath  error:nil] fileSize];
    XCTAssertTrue(fileSize > 100 * 1024);
}

- (void) deleteFile:(NSString*) filePath {
    NSError* error;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}

@end
