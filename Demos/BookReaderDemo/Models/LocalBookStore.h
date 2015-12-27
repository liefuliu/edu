//
//  LocalBookStore.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/25/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalBook.h"

@interface LocalBookStore : NSObject

- (NSArray*) allBookKeys;
- (LocalBook*) getBookWithKey:(NSString*) bookKey;

+ (id) sharedObject;

@end
