//
//  BRDLocalStore.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/30/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LocalBook.h"

@interface BRDBookShuff : NSObject

- (BOOL) doesBookExist: (NSString*) booKey;

- (void) addBook: (NSString*) bookkey;

- (LocalBook*) getBook: (NSString*) bookKey;

+ (id) sharedObject;

@end
