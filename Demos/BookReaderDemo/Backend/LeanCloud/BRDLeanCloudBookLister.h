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
@interface BRDLeanCloudBookLister : NSObject

+ (id) sharedObject;

- (BOOL) connectToServer;

- (BOOL) getListOfBooks:(int) numOfBooks
                     to:(NSArray**) arrayOfBooks;  // NSArray of ServerBook.
- (BOOL) getSummaryInfoForBooks: (NSArray*) arrayOfBooks
                             to: (NSDictionary**) summaryInfo;


- (BOOL) appendSummaryInfoForBooks: (NSArray*) arrayOfBooks
                                to: (NSDictionary**) summaryInfo;


- (BOOL) getListOfBookSets:(int) numOfBooks
                        to:(NSArray**) arrayOfBookSets;

- (BOOL) getListOfBooks:(int) numOfBooks
              inBookSet:(NSString*) bookSetId
                     to:(NSArray**) arrayOfBooks;

@end
