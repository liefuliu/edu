//
//  BookShuffCollectionViewCell.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 5/22/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BookShuffCollectionViewCell.h"
#import "BRDColor.h"

@implementation BookShuffCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    //[self.bookImageView.layer setBorderColor:[BRDColor lowlightTextGrayColor].CGColor];
    //[self.bookImageView.layer setBorderWidth:1.0];
    
    self.bookNameLabel.numberOfLines = 2;
}

@end
