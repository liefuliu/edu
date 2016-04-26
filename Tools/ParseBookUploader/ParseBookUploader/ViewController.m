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

#import <AVOSCloud/AVOSCloud.h>
#import "BUConfig.h"
#import "BUConstants.h"

@interface NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
@end

@implementation NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
    
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
    
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    
    // next make the text appear with an underline
    [attrString addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
    
    [attrString endEditing];
    
    return attrString;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [self.textFieldDbLink setAllowsEditingTextAttributes:YES];
    [self.textFieldDbLink setSelectable:YES];
    
    NSURL* url = [NSURL URLWithString:@"https://leancloud.cn/data.html?appid=tBAtpm2DzImtaakvzHVxEWvX-gzGzoHsz#/Book"];
    
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString: [NSAttributedString hyperlinkFromString:@"查看数据库Book表" withURL:url]];
    
    // set the attributed string to the NSTextField
    [self.textFieldDbLink setAttributedStringValue: string];
    [self.textFieldDbLink setSelectable:YES];
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
        self.textViewFileToUpload.string = @"";
        [self.labelForTextView setStringValue:@"正在上传文件，请耐心等待..."];
        
        for (NSString* file in array) {
            if ( i >= start) {
                if ([self uploadFileToParse:file withSessionId: sessionId]) {
                    NSLog(@"Successfully save the file: %@. Finished %d of %d", file, i+1, [array count]);
                    
                    NSMutableString* theString = [[NSMutableString alloc] init];
                    
                    [theString setString: self.textViewFileToUpload.string];
                    [theString appendString:[NSString stringWithFormat:@"Successfully save the file: %@. Finished %d of %d\n",  file, i+1, [array count]]];
                    [self.textViewFileToUpload setString:theString];
                    [self.view setNeedsDisplay:YES];
                } else {
                    bool retrySuccess = false;
                    for (int retry = 0; retry < 10; retry++) {
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
        
        NSAlert *alertFinished = [NSAlert alertWithMessageText:@"上传成功"
                                         defaultButton:@"OK" alternateButton:nil
                                           otherButton:nil informativeTextWithFormat:
                          [NSString stringWithFormat:@"总共上传%d个文件。", i]];
        [self.labelForTextView setStringValue:@"已上传文件"];
        
        [alertFinished runModal];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"错误"
                                         defaultButton:@"OK" alternateButton:nil
                                           otherButton:nil informativeTextWithFormat:
                          @"没有找到可上传的文件。"];
        
        [alert runModal];
        return;
    }
    
    return;

}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    NSLog(@"controlTextDidChange: stringValue == %@", [textField stringValue]);
    
    NSArray* filePaths = [self getListOfFilePathsMatched:[textField stringValue]];
    NSString* displayingFileNames = [filePaths componentsJoinedByString:@"\n"];
    
    [self.textViewFileToUpload setString:displayingFileNames];
    [self.labelForTextView setStringValue:@"待上传文件"];
}

- (BOOL) fileTypeHasPageInfo : (int) fileType {
    return fileType == (int)kImage || fileType == (int) kPdfFile || fileType == (int) kAudio;
}

- (BOOL) uploadFileToParse: (NSString*) filePath
             withSessionId: (NSString*) sessionId {
    
    
    NSString* theFileName = [filePath lastPathComponent];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSString* serverFileName = [NSString stringWithFormat:@"%@%@", sessionId, theFileName];
    
    BOOL completionStatus = NO;
    if ([BUConfig getBackendToUse] == kBackendParse) {
        PFFile* file = [PFFile fileWithName:serverFileName data:data];
        if (![file save]) {
            return NO;
        }
        
        PFObject *bookPageObject = [PFObject objectWithClassName:@"BookImage"];
        bookPageObject[@"bookName"] = [FilePathUtil getBookName:theFileName];
        int fileType = [FilePathUtil getFileType:theFileName];
        bookPageObject[@"type"] = [NSString stringWithFormat:@"%d",fileType];
        if ([self fileTypeHasPageInfo:fileType]){
            int pageNumber = [FilePathUtil getPageNumber:theFileName];
            bookPageObject[@"pageNumber"] = [NSString stringWithFormat:@"%d", pageNumber];
        }
        
        bookPageObject[@"pageContent"] = file;
        completionStatus = [bookPageObject save];
    } else if ([BUConfig getBackendToUse] == kBackendLeanCloud) {
        /*
                  */
        AVFile* file = [AVFile fileWithName:serverFileName data:data];
        if (![file save]) {
            return NO;
        }
        
        AVObject *bookPageObject = [AVObject objectWithClassName:@"BookImage"];
        bookPageObject[@"bookId"] = [FilePathUtil getBookName:theFileName];
        int fileType = [FilePathUtil getFileType:theFileName];
        bookPageObject[@"type"] = [NSString stringWithFormat:@"%d",fileType];
        if ([self fileTypeHasPageInfo:fileType]) {
            int pageNumber = [FilePathUtil getPageNumber:theFileName];
            bookPageObject[@"pageNumber"] = [NSString stringWithFormat:@"%d", pageNumber];
        }
        
        bookPageObject[@"pageContent"] = file;
        completionStatus = [bookPageObject save];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"错误"
                                         defaultButton:@"OK" alternateButton:nil
                                           otherButton:nil informativeTextWithFormat:
                          @"meiyou shixian"];
        
        [alert runModal];
        completionStatus = NO;
    }
    
    return completionStatus;
}

- (NSString*) getSessionId {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMDD_HHmmss_"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

- (NSArray*) getListOfFilePathsMatched : (NSString*) filePattern {
    NSString* userName = NSUserName();
    NSString* searchPath = [NSString stringWithFormat:@"file:///users/%@/Desktop/PicBooks/", userName];
    NSURL *url = [NSURL URLWithString:searchPath];
    
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
