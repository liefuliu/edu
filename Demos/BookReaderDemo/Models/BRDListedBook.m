//
//  ServerBook.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/24/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDListedBook.h"

@implementation BRDListedBook

- (id) initBook:(NSString*) bookId
           name:(NSString*) bookName
         author:(NSString*) author
      bookNotes:(NSString*) bookNotes
     totalPages:(int) totalPages
          cover:(NSData*) cover
  imageFileType:(int) imageFileType {
    self = [super init];
    if (self) {
        _bookId = bookId;
        _bookName = bookName;
        _bookNotes = bookNotes;
        _author = author;
        _totalPages = totalPages;
        _cover = cover;
        _imageFileType = imageFileType;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        self.bookId = [aDecoder decodeObjectForKey:@"bookId"];
        self.bookName = [aDecoder decodeObjectForKey:@"bookName"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.bookNotes = [aDecoder decodeObjectForKey:@"bookNotes"];
        self.totalPages = [aDecoder decodeIntForKey:@"totalPages"];
        self.cover = (NSData*)[aDecoder decodeObjectForKey:@"cover"];
        self.imageFileType = [aDecoder decodeIntForKey:@"imageFileType"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.bookId forKey:@"bookId"];
    [encoder encodeObject:self.bookName forKey:@"bookName"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:self.bookNotes forKey:@"bookNotes"];
    [encoder encodeInt:self.totalPages forKey:@"totalPages"];
    [encoder encodeObject:self.cover forKey:@"cover"];
    [encoder encodeInt:self.imageFileType forKey:@"imageFileType"];
}



@end
