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


@end
