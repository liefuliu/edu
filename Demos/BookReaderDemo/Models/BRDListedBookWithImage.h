//
//  BRDListedBookWithImage.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 6/4/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BRDBookSummary.h"
#import "BRDListedBook.h"

@interface BRDListedBookWithImage : NSObject

@property (readonly) BRDListedBook* bookInfo;
@property (readonly) BRDBookSummary* bookSummaryWithImage;

- (id) initBook:(BRDListedBook*) bookInfo
 withSummaryImage:(BRDBookSummary*) bookSummaryWithImage;


@end
