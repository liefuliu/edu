//
//  BookHandler.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/22/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

// A class responsbile to get a list of book names from either book server.
// Usage
// BookLister* bookLister = [BookLister init];
// if (![bookLister connectToServer:(NSError*) error]) {
//    // Handle connection error;
// } else {
//     NSArray* firstBatchOfBooks = [bookLister getListOfBooks:100 startFrom:0];
//     NSArray* secondBatchOfBooks = [bookLister getListOfBooks:100 startFrom:100];
//     ...
// }
@interface BRDBookLister : NSObject

+ (id) sharedObject;

- (BOOL) connectToServer;

- (BOOL) getListOfBooks:(int) numOfBooks
                  startFrom:(int) pageOffset
                         to:(NSArray**) arrayOfBooks;  // NSArray of ServerBook.
- (BOOL) getSummaryInfoForBooks: (NSArray*) arrayOfBooks
                             to: (NSDictionary**) summaryInfo;

@end
