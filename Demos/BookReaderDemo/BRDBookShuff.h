//
//  BRDLocalStore.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/30/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocalBook.h"
#import "LocalBookStatus.h"
#import "BRDBookSummary.h"
#import "BRDCachedBooks.h"

@interface BRDBookShuff : NSObject

- (BOOL) doesBookExist: (NSString*) booKey;

- (void) addBook:(LocalBook*) bookInfo
          forKey:(NSString*) bookKey;

- (void) updateBook:(LocalBook*) bookInfo
             forKey:(NSString*) bookKey;

- (void) deleteBook: (NSString*) bookKey;

- (LocalBook*) getBook: (NSString*) bookKey;

- (NSArray*) getAllBookKeys;

// TODO: consider to move this function to another class
- (void) updateBookStatus: (LocalBookStatus*) localBookStatus
                   forKey: (NSString*) bookKey;

- (LocalBookStatus*) getBookStatus: (NSString*) bookKey;

// Returns false if no books are cached.
- (BOOL) getCachedBooks:(BRDCachedBooks**) cachedBooks;

- (void) setCachedBooks:(BRDCachedBooks*) cachedBooks;

+ (id) sharedObject;

@end
