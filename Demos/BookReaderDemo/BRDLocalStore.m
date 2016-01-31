//
//  BRDLocalStore.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/30/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDLocalStore.h"


@interface BRDLocalStore()

//@property NSMutableSet* downloadedBookKeys;

@end

@implementation BRDLocalStore

const NSString* kDownloadedBookKeyString = @"downloaded_book_key";

+ (id)sharedObject {
    static BRDLocalStore *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[self alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:kDownloadedBookKeyString]) {
            NSMutableDictionary* bookDictionary = [[NSMutableDictionary alloc] init];
            [defaults setObject:bookDictionary forKey:kDownloadedBookKeyString];
        }
    });
    return object;
}

- (id) init {
    self = [super init];
    if (self) {
        self.bookNameKey = kDownloadedBookKeyString;
    }
    return self;
}

- (BOOL) isBookDownloaded: (NSString*) bookKey {
    return NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* bookDictionary = [defaults objectForKey:kDownloadedBookKeyString];
    
    return ([bookDictionary objectForKey:bookKey] != nil);
}

- (void) markBookAsDownloaded: (NSString*) bookkey {
    if ([self isBookDownloaded:bookkey]) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* bookDictionary = (NSDictionary*)[defaults objectForKey:kDownloadedBookKeyString];
    NSMutableDictionary* newBookDictionary = [[NSMutableDictionary alloc] initWithDictionary:bookDictionary];

    //int randomValue = -1;
   //  NSNumber randomValue = NSNumber
    NSString* randomValue = @"RandomValue";
    [newBookDictionary setValue:randomValue forKey:bookkey];
    [defaults setObject:newBookDictionary forKey:kDownloadedBookKeyString];
}


@end
