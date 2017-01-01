//
//  TSTBookSetCollectionViewCell.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/19/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "TSTBookSetCollectionViewCell.h"

@implementation TSTBookSetCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self layoutSubviews];
    /*
    NSDictionary *nameMap = @{@"imageView": self.bookImageView,
                              @"label": self.bookNameLabel};
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSLog(@"screenRect.width = %s, screenRect.height = %s",
          screenRect.size.width, screenRect.size.height);
     */
    
    [self.bookImageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.bookImageView.layer setShadowOpacity:0.8];
    [self.bookImageView.layer setShadowRadius:3.0];
    [self.bookImageView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self setNeedsDisplay];
    
}

@end
