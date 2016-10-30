//
//  BRDListedBookSet.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 9/1/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDListedBookSet.h"

@implementation BRDListedBookSet

- (id) initBookSet:(NSString*) bookSetId
              name:(NSString*) bookSetName
             notes:(NSString*) bookSetNotes {
    self = [super init];
    if (self) {
        _bookSetId = bookSetId;
        _bookSetName = bookSetName;
        _bookSetNotes = bookSetNotes;
    }
    return self;
}




- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        self.bookSetId = [aDecoder decodeObjectForKey:@"bookSetId"];
        self.bookSetName = [aDecoder decodeObjectForKey:@"bookSetName"];
        self.bookSetNotes = [aDecoder decodeObjectForKey:@"bookSetNotes"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.bookSetId forKey:@"bookSetId"];
    [encoder encodeObject:self.bookSetName forKey:@"bookSetName"];
    [encoder encodeObject:self.bookSetNotes forKey:@"bookSetNotes"];
}


@end
