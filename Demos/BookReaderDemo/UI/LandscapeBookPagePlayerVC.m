//
//  BookPlayerVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "LandscapeBookPagePlayerVC.h"
#import "LocalBook.h"
#import "BRDPathUtil.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BRDBookShuff.h"
#import "BRDFileUtil.h"
#import "BRDConstants.h"
#import <PDFImage/PDFImage.h>

@interface LandscapeBookPagePlayerVC ()


@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation LandscapeBookPagePlayerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view removeConstraints:self.view.constraints];
    
    // Set constraits for
    // @property (weak, nonatomic) IBOutlet UIImageView *pageImageView;
    // @property (weak, nonatomic) IBOutlet UITextView *translatedTextView;
    NSDictionary *nameMap = @{@"pageImageView": self.pageImageView,
                            @"translatedTextView": self.translatedTextView};
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int screenWidth = screenRect.size.width;
    NSString* horizontalConstraintsImageFormat = [NSString stringWithFormat:@"H:|-%d-[pageImageView]-%d-|",
                                                  screenWidth / 5, screenWidth * 3 / 10];
    
    
    NSArray* horizontalConstraintsImage =
    [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintsImageFormat options:0 metrics:nil views:nameMap];
    
    NSString* horizontalConstraintsTextFormat = [NSString stringWithFormat:@"H:[pageImageView]-%d-[translatedTextView]-%d-|", screenWidth/50, screenWidth/20];
    
    
    NSArray* horizontalConstraintsText =
    [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintsTextFormat options:0 metrics:nil views:nameMap];
    
    
    NSArray* verticalConstraintsImage =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pageImageView]-0-|" options:0 metrics:nil views:nameMap];
    
    int screenHeight= screenRect.size.height;
    NSString* verticalConstraintsTextFormat = [NSString stringWithFormat:@"V:|-%d-[translatedTextView]-0-|",
                                                  screenHeight / 3];

    NSArray* verticalConstraintsText =
    [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintsTextFormat options:0 metrics:nil views:nameMap];
    
    [self.view addConstraints:horizontalConstraintsImage];
    [self.view addConstraints:horizontalConstraintsText];
    [self.view addConstraints:verticalConstraintsImage];
    [self.view addConstraints:verticalConstraintsText];
    
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
    

}


@end
