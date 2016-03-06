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
#import "BRDFileUtil.h"

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

- (void) showPageAtIndex:(int) pageIndex {
    self.pageImageView.image = [UIImage imageWithData:[BRDFileUtil getBookImage:self.localBookKey onPage:pageIndex]];
    
    if (pageIndex < self.translatedText.count &&
        ((NSString*) self.translatedText[pageIndex]).length > 0) {
        self.translatedTextView.text = (NSString*)self.translatedText[pageIndex];
        self.translatedTextView.hidden = NO;
    } else {
        self.translatedTextView.hidden = YES;
    }
}


@end
