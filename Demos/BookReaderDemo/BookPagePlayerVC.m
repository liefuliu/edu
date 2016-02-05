//
//  BookPlayerVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "BookPagePlayerVC.h"
#import "LocalBook.h"
#import "BRDPathUtil.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BRDBookShuff.h"

@interface BookPagePlayerVC ()

@property int currentPage;
@property LocalBook* localBookInfo;
@property NSString* localBookKey;
@property NSArray* translatedText;

@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation BookPagePlayerVC

- (id) initWithBookKey:(NSString*) localBookKey
              withPage:(int) pageIndex
    withTranslatedText: (NSArray*) translatedText {
    if (self = [super init]) {
        self.localBookKey = localBookKey;
        self.localBookInfo = [[BRDBookShuff sharedObject] getBook:self.localBookKey];
        self.page = pageIndex;
        self.translatedText = translatedText;
    }
    return self;
}

- (NSString*) intToString:(int) integer {
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

- (void) showPageAtIndex:(int) pageIndex {
    NSString* documentsDirectory = [BRDPathUtil applicationDocumentsDirectoryPath];
    NSString* fileName = [NSString stringWithFormat:@"%@-picture-%@.jpg",
                          self.localBookInfo.filePrefix,
                          [self intToString:pageIndex+1]]; // 绘本页从1开始计数。
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *imgData = [NSData dataWithContentsOfFile:filePath];
    self.pageImageView.image = [UIImage imageWithData:imgData];
    
    if (pageIndex < self.translatedText.count &&
        ((NSString*) self.translatedText[pageIndex]).length > 0) {
        self.translatedTextView.text = (NSString*)self.translatedText[pageIndex];
        self.translatedTextView.hidden = NO;
    } else {
        self.translatedTextView.hidden = YES;
    }
}


@end
