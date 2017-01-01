//
//  TSTPictureBookStoreCell.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 11/20/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "TSTPictureBookStoreCell.h"

@implementation TSTPictureBookStoreCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bookSetNotesTextView.inputAssistantItem.leadingBarButtonGroups = @[];
    self.bookSetNotesTextView.inputAssistantItem.trailingBarButtonGroups = @[];
    
    
    [self.sampleBookImageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.sampleBookImageView.layer setShadowOpacity:0.8];
    [self.sampleBookImageView.layer setShadowRadius:3.0];
    [self.sampleBookImageView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self setNeedsDisplay];
    
}

@end
