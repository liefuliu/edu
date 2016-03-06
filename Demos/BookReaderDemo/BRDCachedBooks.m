//
//  BRDCachedBooks.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/25/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDCachedBooks.h"

@implementation BRDCachedBooks 

-(id)initWithBookList:(NSArray*)bookList
       withCovers:(NSDictionary*)bookCoverImages {
    self = [super init];
    if (self) {
        self.bookList = bookList;
        self.bookCoverImages = bookCoverImages;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        self.bookList = [aDecoder decodeObjectForKey:@"bookList"];
        self.bookCoverImages = [aDecoder decodeObjectForKey:@"bookCoverImageList"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.bookList forKey:@"bookList"];
    [encoder encodeObject:self.bookCoverImages forKey:@"bookCoverImageList"];
}


@end
