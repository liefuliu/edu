//
//  ViewController.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 1/17/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "ViewController.h"
#import "FilePathUtil.h"
#import <Parse/Parse.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)buttonClicked:(id)sender {
    NSLog(@"button clicked");
    [self EnumerateDir];
}

- (void) EnumerateDir {
    //NSString* sessionId = [self getSessionId];
    NSString* sessionId = @"20160117_211559_";
    NSLog(@"session id = %@", sessionId);
    
    NSURL *url = [NSURL URLWithString:@"file:///Users/liefuliu/src/edu/Demos/BookReaderDemo/Books/"];
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
                           NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtURL:url
                      includingPropertiesForKeys:properties
                      options:(NSDirectoryEnumerationSkipsHiddenFiles)
                      error:&error];
    if (array != nil) {
        // Handle the error
        int i = 0;
        int start = 0;
        for (NSString* file in array) {
            if ( i >= start) {
                if ([self uploadFileToParse:file withSessionId: sessionId]) {
                    NSLog(@"Successfully save the file: %@. Finished %d of %d", file, i+1, [array count]);
                } else {
                    bool retrySuccess = false;
                    for (int retry = 0; retry < 2; retry++) {
                        if ([self uploadFileToParse:file withSessionId: sessionId]) {
                            retrySuccess = true;
                            break;
                        }
                    }
                    
                    if (retrySuccess) {
                        NSLog(@"Successfully retry to save the file: %@. Finished %d of %d", file, i+1, [array count]);
                    } else {
                        NSLog(@"Failed too many times to save the file: %@. ", file);
                        break;
                    }
                }
                
            }
            
            ++i;
            /*
             + (nullable instancetype)fileWithName:(nullable NSString *)name
             contentsAtPath:(nonnull NSString *)path;
             */
        }
    }
}

- (BOOL) uploadFileToParse: (NSString*) filePath
             withSessionId: (NSString*) sessionId {
    NSString* theFileName = [filePath lastPathComponent];

    NSData* data = [NSData dataWithContentsOfFile:filePath];
    
    NSString* parseFileName = [NSString stringWithFormat:@"%@%@", sessionId, theFileName];
    PFFile* file = [PFFile fileWithName:parseFileName data:data];
    if (![file save]) {
        return NO;
    }
    
    PFObject *bookPageObject = [PFObject objectWithClassName:@"BookImage"];
    bookPageObject[@"bookName"] = [FilePathUtil getBookName:theFileName];
    int fileType = [FilePathUtil getFileType:theFileName];
    bookPageObject[@"type"] = [NSString stringWithFormat:@"%d",fileType];
    if (fileType == (int)kImage || fileType == (int) kAudio) {
        int pageNumber = [FilePathUtil getPageNumber:theFileName];
        bookPageObject[@"pageNumber"] = [NSString stringWithFormat:@"%d", pageNumber];
    }
    
    bookPageObject[@"pageContent"] = file;
    return [bookPageObject save];
}

- (NSString*) getSessionId {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMDD_HHmmss_"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

@end
