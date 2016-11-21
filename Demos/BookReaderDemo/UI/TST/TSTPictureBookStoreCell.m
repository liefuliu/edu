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
    
}

@end
