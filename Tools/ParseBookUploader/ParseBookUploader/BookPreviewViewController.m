//
//  BookPreviewViewController.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 7/10/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BookPreviewViewController.h"
#import "FilePathUtil.h"
#import "BUConstants.h"

#import <AVFoundation/AVFoundation.h>

@interface BookPreviewViewController ()

//@property NSArray* imagePageIndices;
//@property NSArray* audioPageIndices;
@property BOOL hasTranslation;
@property NSArray* translatedText;
@property int totalPages;
@property NSString* bookName;

@property int currentPage;
@property AVAudioPlayer* player;

// @property BOOL hasError;

@end

@implementation BookPreviewViewController

id _keyMonitor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.view.window setTitle:@"预览绘本"];
    
    if (_keyMonitor == nil) {
    _keyMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
        
        unichar character = [[event characters] characterAtIndex:0];
        switch (character) {
            case NSLeftArrowFunctionKey:
                [self tryPreviousPage];
                break;
            case NSRightArrowFunctionKey:
                [self tryNextPage];
                break;
            default:
                break;
        }
        return event;
    }];
    }
    NSFont *font = [NSFont userFontOfSize:17.0];
    [self.displayTextView setFont:font];
    
    [self reloadCurrentPage];
}

- (IBAction)gotoPreviousPage:(id)sender {
    [self tryPreviousPage];
}

- (void) tryPreviousPage {
    if (self.currentPage > 0) {
        [self previousPage];
        [self reloadCurrentPage];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"提示"
                                         defaultButton:@"确定" alternateButton:nil
                                           otherButton:nil informativeTextWithFormat:
                          @"已经翻到第一页"];
        [alert runModal];
        
    }

}

- (IBAction)gotoNextPage:(id)sender {
    [self tryNextPage];
}

- (void) tryNextPage {
    if (self.currentPage < self.totalPages - 1) {
        [self nextPage];
        [self reloadCurrentPage];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"提示"
                                         defaultButton:@"确定" alternateButton:nil
                                           otherButton:nil informativeTextWithFormat:
                          @"已经翻到最后一页"];
        [alert runModal];
    }
}

-(BOOL) loadBookFiles: (NSArray*) bookFileNames {
    if (self) {
        if ([bookFileNames count] > 0) {
            self.bookName = [FilePathUtil getBookName:[bookFileNames[0] lastPathComponent]];
            self.totalPages = 0;
            for (NSString* filePath in bookFileNames) {
                NSString* fileName = [filePath lastPathComponent];
                if ([FilePathUtil getFileType:fileName] == kFileTypeUnknown) {
                    continue;
                }
                
                if ([FilePathUtil getFileType:fileName] == kTranslation) {
                    self.translatedText = [BookPreviewViewController extractTranslatedText:fileName];
                } else if ([FilePathUtil getFileType:fileName] == kCover) {
                    
                } else {
                
                int pageIndex = [FilePathUtil getPageNumber:fileName];
                if (pageIndex > self.totalPages) {
                    self.totalPages = pageIndex;
                }
                }
                
                
            }
        }
        return true;
    } else {
        return false;
    }
    
}


+ (NSArray*) extractTranslatedText: (NSString*) fileName {
    NSString* filePath = [BookPreviewViewController filePathOfFile:fileName];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding error:nil];
    
    
    NSArray* allLinedStrings =
    [fileContents componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    allLinedStrings = [allLinedStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    NSMutableArray* translatedText = [[NSMutableArray alloc] init];
    for (NSString* encodedLine in allLinedStrings) {
        [translatedText addObject:[encodedLine stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
    }
    
    return translatedText;
}

+ (NSString*) filePathOfFile:(NSString*) filename {
    NSString* userName = NSUserName();
    NSString* directoryPath = [NSString stringWithFormat:kBookDirectory, userName];
    
    
    //NSURL* imageFileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", directoryPath, imageFileName]];
    NSString* filePath = [NSString stringWithFormat:@"%@%@", directoryPath, filename];
    filePath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    return filePath;
}

- (void) reloadImage {
    NSString* imageFileName = [NSString stringWithFormat:@"%@-picture-%@.jpg",
                               self.bookName,
                               [BookPreviewViewController intToString:self.currentPage+1]];
    NSString* filePath = [BookPreviewViewController filePathOfFile:imageFileName];
    
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    
    
    NSImage* image = [[NSImage alloc] initWithData: data];
    self.pageImageView.image = image;
    
}

- (void) displayTranslationText {
    [self.displayTextView setString: self.translatedText[self.currentPage]];

}

- (void) playSound {
    NSString* mp3FileName = [NSString stringWithFormat:@"%@-audio-%@.mp3",
                             self.bookName,
                             [BookPreviewViewController intToString:self.currentPage+1]];
    
    NSString* filePath = [BookPreviewViewController filePathOfFile:mp3FileName];

    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: filePath];
    AVAudioPlayer* audioPlayer  =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    self.player = audioPlayer;
    [self.player play];


}

- (void) reloadCurrentPage {
    [self reloadImage];
    [self displayTranslationText];
    [self playSound];
}

- (void) nextPage {
    if (self.currentPage < self.totalPages - 1) {
        ++self.currentPage;
    }
}

- (void) previousPage {
    if (self.currentPage > 0) {
        --self.currentPage;
    }
}



+ (NSString*) intToString:(int) integer {
    if (integer < 10) {
        return [NSString stringWithFormat:@"000%d", integer];
    } else if (integer < 100) {
        return [NSString stringWithFormat:@"00%d", integer];
    } else if (integer < 1000) {
        return [NSString stringWithFormat:@"0%d", integer];
    } else {
        return [NSString stringWithFormat:@"%d", integer];
    }
}


@end
