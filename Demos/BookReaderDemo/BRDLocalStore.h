//
//  BRDLocalStore.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/30/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDLocalStore : NSObject

@property NSString* bookNameKey;

- (BOOL) isBookDownloaded: (NSString*) booKey;

- (void) markBookAsDownloaded: (NSString*) bookkey;

+ (id) sharedObject;

@end
