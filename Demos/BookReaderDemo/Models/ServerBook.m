//
//  ServerBook.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/24/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "ServerBook.h"

@implementation ServerBook

- (id) initBook:(NSString*) bookName
         author:(NSString*) author
     totalPages:(int) totalPages
          cover:(NSData*) cover {
    self = [super init];
    if (self) {
        _bookName = bookName;
        _author = author;
        _totalPages = totalPages;
        _cover = cover;
    }
    return self;
}

@end
