//
//  BookPlayerVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "BookPagePlayerVC.h"
#import "LocalBook.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LocalBookStore.h"

@interface BookPagePlayerVC ()

/*
@property int totalPages;
@property NSArray* translatedText;
*/

@property int currentPage;
@property LocalBook* localBookInfo;
@property NSString* localBookKey;

@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation BookPagePlayerVC

- (id) initWithBookKey:(NSString*) localBookKey
              withPage:(int) pageIndex {
    if (self = [super init]) {
        self.localBookKey = localBookKey;
        self.localBookInfo = [[LocalBookStore sharedObject] getBookWithKey:self.localBookKey];
        self.page = pageIndex;
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
    NSString* imageFilePath = [NSString stringWithFormat:@"%@/%@-picture-%@.jpg",
                               [[NSBundle mainBundle] resourcePath],
                               self.localBookInfo.filePrefix,
                               [self intToString:pageIndex+1]]; // 绘本页从1开始计数。
    self.pageImageView.image = [UIImage imageWithContentsOfFile:imageFilePath];
    if (pageIndex < self.localBookInfo.translatedText.count &&
        ((NSString*)self.localBookInfo.translatedText[pageIndex]).length > 0) {
        self.translatedTextView.text = (NSString*)self.localBookInfo.translatedText[pageIndex];
        self.translatedTextView.hidden = NO;
    } else {
        self.translatedTextView.hidden = YES;
    }
}


@end
