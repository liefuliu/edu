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
downloadedPages:(int) downloadedPages
     filePrefix:(NSString*) filePrefix
hasTranslatedText:(BOOL) hasTranslatedText
  imageFileType:(int) imageFileType {
    self = [super init];
    if (self) {
        _bookName = bookName;
        _author = author;
        _totalPages = totalPages;
        _downloadedPages = downloadedPages;
        _filePrefix = filePrefix;
        _hasTranslatedText = hasTranslatedText;
        _imageFileType = imageFileType;
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
        self.downloadedPages = [[aDecoder decodeObjectForKey:@"downloadedPages"] intValue];
        self.filePrefix = [aDecoder decodeObjectForKey:@"filePrefix"];
        self.hasTranslatedText = [[aDecoder decodeObjectForKey:@"hasTranslatedText"]boolValue];
        self.imageFileType = [[aDecoder decodeObjectForKey:@"imageFileType"]intValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.bookName forKey:@"bookName"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:[NSNumber numberWithInt:self.totalPages] forKey:@"totalPages"];
    [encoder encodeObject:[NSNumber numberWithInt:self.downloadedPages] forKey:@"downloadedPages"];
    [encoder encodeObject:self.filePrefix forKey:@"filePrefix"];
    [encoder encodeObject:[NSNumber numberWithBool:self.hasTranslatedText] forKey:@"hasTranslatedText"];
    [encoder encodeObject:[NSNumber numberWithInt:self.imageFileType] forKey:@"imageFileType"];
}


@end
