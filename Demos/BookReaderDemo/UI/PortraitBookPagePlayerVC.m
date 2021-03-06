//
//  BookPlayerVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "PortraitBookPagePlayerVC.h"
#import "LocalBook.h"
#import "BRDPathUtil.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BRDBookShuff.h"
#import "BRDFileUtil.h"
#import "BRDConstants.h"
#import <PDFImage/PDFImage.h>

@interface PortraitBookPagePlayerVC ()


@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation PortraitBookPagePlayerVC

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void) showPageAtIndex:(int) pageIndex {
    if (self.localBookInfo.imageFileType == kImageFileFormatJpg) {
     
    self.pageImageView.image = [UIImage imageWithData:[BRDFileUtil getBookImage:self.localBookKey
                                                                         onPage:pageIndex
                                                                  imageFileType:self.localBookInfo.imageFileType]];
    } else if (self.localBookInfo.imageFileType == kImageFileFormatPdf) {
        PDFImage* pdfImage = [PDFImage imageWithData:[BRDFileUtil getBookImage:self.localBookKey
                                                                             onPage:pageIndex
                                                                      imageFileType:self.localBookInfo.imageFileType]];
        PDFImageOptions *options = [PDFImageOptions optionsWithSize:self.pageImageView.frame.size];
        self.pageImageView.image = [pdfImage imageWithOptions:options];

    }
    
    if (pageIndex < self.translatedText.count &&
        ((NSString*) self.translatedText[pageIndex]).length > 0) {
        self.translatedTextView.text = (NSString*)self.translatedText[pageIndex];
        self.translatedTextView.hidden = NO;
    } else {
        self.translatedTextView.hidden = YES;
    }
    
    [self.translatedTextView setFont:[UIFont systemFontOfSize:16]];
    [self.translatedTextView setTextColor:[UIColor whiteColor]];
    
    [self.translatedTextView setBackgroundColor:[self defaultBackgroundColor]];
}


@end
