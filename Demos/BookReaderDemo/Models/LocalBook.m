//
//  LocalBook.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/25/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//
#import "BRDPathUtil.h"
#import "LocalBook.h"

@implementation LocalBook


- (id) initBook:(NSString*) bookName
         author:(NSString*) author
     totalPages:(int) totalPages
     filePrefix:(NSString*) filePrefix
hasTranslatedText:(BOOL) hasTranslatedText {
    self = [super init];
    if (self) {
        _bookName = bookName;
        _author = author;
        _totalPages = totalPages;
        _filePrefix = filePrefix;
        _hasTranslatedText = hasTranslatedText;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        self.bookName = [aDecoder decodeObjectForKey:@"bookName"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.totalPages = [[aDecoder decodeObjectForKey:@"totalPages"] intValue];
        self.filePrefix = [aDecoder decodeObjectForKey:@"filePrefix"];
        self.hasTranslatedText = [[aDecoder decodeObjectForKey:@"hasTranslatedText"]boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.bookName forKey:@"bookName"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:[NSNumber numberWithInt:self.totalPages] forKey:@"totalPages"];
    [encoder encodeObject:self.filePrefix forKey:@"filePrefix"];
    [encoder encodeObject:[NSNumber numberWithBool:self.hasTranslatedText] forKey:@"hasTranslatedText"];
    
}


@end
