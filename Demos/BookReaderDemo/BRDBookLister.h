//
//  BRDBookLister.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 3/6/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BRDBookLister

- (BOOL) connectToServer;

- (BOOL) getListOfBooks:(int) numOfBooks
              startFrom:(int) pageOffset
                     to:(NSArray**) arrayOfBooks;  // NSArray of server book.

- (BOOL) getListOfBookSets:(int) numOfBooks
              startFrom:(int) pageOffset
                     to:(NSArray**) arrayOfBookSets;  // NSArray of server book set.

- (BOOL) getSummaryInfoForBooks: (NSArray*) arrayOfBooks
                             to: (NSDictionary**) summaryInfo;

- (BOOL) appendSummaryInfoForBooks: (NSArray*) arrayOfBooks
                                to: (NSDictionary**) summaryInfo;
@end
