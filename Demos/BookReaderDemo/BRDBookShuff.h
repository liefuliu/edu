//
//  BRDLocalStore.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/30/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocalBook.h"
#import "BRDBookSummary.h"

@interface BRDBookShuff : NSObject

- (BOOL) doesBookExist: (NSString*) booKey;

- (void) addBook:(LocalBook*) bookInfo
          forKey:(NSString*) bookKey;

- (void) deleteBook: (NSString*) bookKey;

- (LocalBook*) getBook: (NSString*) bookKey;

- (NSArray*) getAllBookKeys;

+ (id) sharedObject;

@end
