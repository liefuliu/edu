//
//  LocalBookStatus.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/25/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "LocalBookStatus.h"

@implementation LocalBookStatus


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        NSString* dateString = [aDecoder decodeObjectForKey:@"lastReadDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss a";
        self.lastReadDate = [dateFormatter dateFromString:dateString];
        self.pageLastRead = [[aDecoder decodeObjectForKey:@"pageLastRead"] intValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:self.lastReadDate];
    [encoder encodeObject:dateString forKey:@"lastReadDate"];
    [encoder encodeObject:[NSNumber numberWithInt:self.pageLastRead] forKey:@"pageLastRead"];
}
    

@end
