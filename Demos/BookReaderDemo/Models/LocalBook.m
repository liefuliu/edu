//
//  LocalBook.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/25/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "LocalBook.h"

@implementation LocalBook


- (id) initBook:(NSString*) bookName
         author:(NSString*) author
     totalPages:(int) totalPages
     filePrefix:(NSString*) filePrefix
 translatedText:(NSArray*) translatedText {
    self = [super init];
    if (self) {
        _bookName = bookName;
        _author = author;
        _totalPages = totalPages;
        _filePrefix = filePrefix;
        _translatedText = translatedText;
    }
    return self;
}

@end
