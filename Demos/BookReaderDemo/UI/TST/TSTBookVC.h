//
//  TSTBookVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/28/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRDListedBook.h"BRDListedBook

@interface TSTBookVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookSampleLabel;
@property (weak, nonatomic) IBOutlet UITextView *bookNotesTextView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UILabel *downloadingLabel;
@property (weak, nonatomic) IBOutlet UIButton *deletingLabel;
/*
@property (weak, nonatomic) IBOutlet UIProgressView *deletingProgressView;*/
@property (weak, nonatomic) IBOutlet UIProgressView *removingProgressView;

-(id) initWithBookInfo: (BRDListedBook*) bookInfo
             bookImage: (NSData*) bookImageData;
@end
