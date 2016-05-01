//
//  BRDBookSummary.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/30/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDBookSummary.h"

@implementation BRDBookSummary



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.imageData = (NSData*)[aDecoder decodeObjectForKey:@"imageData"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.imageData forKey:@"imageData"];
}


@end
