//
//  BRDListedBookWithImage.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 6/4/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDListedBookWithImage.h"

@implementation BRDListedBookWithImage

- (id) initBook:(BRDListedBook*) bookInfo
withSummaryImage:(BRDBookSummary*) bookSummaryWithImage {
    self = [super init];
    if (self) {
        _bookInfo = bookInfo;
        _bookSummaryWithImage = bookSummaryWithImage;
    }
    return self;
}

@end
