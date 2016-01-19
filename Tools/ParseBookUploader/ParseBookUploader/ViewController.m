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
    if ([self.textFieldFileName stringValue].length == 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"输入错误"
                                         defaultButton:@"OK" alternateButton:nil
                                           otherButton:nil informativeTextWithFormat:
                          @"文件名不能为空"];

        [alert runModal];
        return;
    }
    
    NSLog(@"button clicked");
    [self EnumerateDir];
}

- (void) EnumerateDir {
    //NSString* sessionId = [self getSessionId];
    NSString* sessionId = @"20160117_211559_";
    NSLog(@"session id = %@", sessionId);
    
    NSArray* array = [self getListOfFilePathsMatched:[self.textFieldFileName stringValue]];
    
    if ([array count] > 0) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        [alert setMessageText:[NSString stringWithFormat:@"是否要上传列表中%d个文件?", [array count]]];
        [alert setInformativeText:@"上传将覆盖现有文件"];
        [alert setAlertStyle:NSWarningAlertStyle];

        if ([alert runModal] != NSAlertFirstButtonReturn) {
            return;
        }

        
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
        }
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"错误"
                                         defaultButton:@"OK" alternateButton:nil
                                           otherButton:nil informativeTextWithFormat:
                          @"没有找到可上传的文件。"];
        
        [alert runModal];
        return;
    }
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    NSLog(@"controlTextDidChange: stringValue == %@", [textField stringValue]);
    
    NSArray* filePaths = [self getListOfFilePathsMatched:[textField stringValue]];
    NSString* displayingFileNames = [filePaths componentsJoinedByString:@"\n"];
    
    [self.textViewFileToUpload setString:displayingFileNames];
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

- (NSArray*) getListOfFilePathsMatched : (NSString*) filePattern {
    NSURL *url = [NSURL URLWithString:@"file:///Users/liefuliu/src/edu/Demos/BookReaderDemo/Books/"];
    
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
                           NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtURL:url
                      includingPropertiesForKeys:properties
                      options:(NSDirectoryEnumerationSkipsHiddenFiles)
                      error:&error];
    
    // 检查文件名是否匹配正则表达式。
    NSString* fileRegex = [self.textFieldFileName stringValue];
    NSMutableArray* arrayFilePath = [[NSMutableArray alloc] init];
    
    for (NSString* item in array) {
        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:fileRegex options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSString* theFileName = [item lastPathComponent];
        NSTextCheckingResult *match = [regex firstMatchInString:theFileName options:0 range:NSMakeRange(0, [theFileName length])];
        
        if (match) {
            [arrayFilePath addObject:item];
        }
    }
    
    return arrayFilePath;
}



@end