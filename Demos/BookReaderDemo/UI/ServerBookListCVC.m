//
//  ServerBookListCVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/31/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "ServerBookListCVC.h"
#import "BRDColor.h"

@implementation ServerBookListCVC

- (void)awakeFromNib {
    // Initialization code
    [self.imageView.layer setBorderColor:[BRDColor lowlightTextGrayColor].CGColor];
    [self.imageView.layer setBorderWidth:1.0];
    [self.downloadButton setHidden:YES];
}

@end
