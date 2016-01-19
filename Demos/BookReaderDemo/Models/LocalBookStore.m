//
//  LocalBookStore.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/25/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "LocalBookStore.h"

@interface LocalBookStore()

@property NSDictionary* bookStore;

@end

@implementation LocalBookStore

- (NSArray*) allBookKeys {
    return [self.bookStore allKeys];
}

- (LocalBook*) getBookWithKey:(NSString*) bookKey {
    return (LocalBook*)[self.bookStore objectForKey:bookKey];
}

+ (id)sharedObject {
    static LocalBookStore *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[self alloc] init];
    });
    return object;
}

- (id)init {
    if (self = [super init]) {
        LocalBook* bookStanley = [LocalBookStore createBook:@"stanley"];
        LocalBook* bookTheLetters = [LocalBookStore createBook:@"theletters"];
        LocalBook* bookOliver = [LocalBookStore createBook:@"oliver"];
        
        _bookStore = [[NSDictionary alloc] initWithObjectsAndKeys:
                      
                      bookStanley,
                    @"stanley",
                      bookTheLetters,
                      @"theletters",
                      bookOliver,
                      @"oliver",
                      nil];
    }
    return self;
}

+ (LocalBook*) createBook: (NSString*) bookKey {
    if (bookKey == @"stanley") {
       return [[LocalBook alloc] initBook:@"Stanley" author:@"Syn Doff" totalPages:58
                               filePrefix:@"stanley" hasTranslatedText:YES];
    } else if (bookKey == @"theletters") {
        return [[LocalBook alloc] initBook:@"The Letters" author:@"" totalPages:26
                                filePrefix:@"theletters" hasTranslatedText:NO];
    } else if (bookKey == @"oliver") {
        return [[LocalBook alloc] initBook:@"Oliver" author:@"Syn Doff" totalPages: 60
                                filePrefix:@"oliver" hasTranslatedText:YES];
    }
    return nil;
}


@end
