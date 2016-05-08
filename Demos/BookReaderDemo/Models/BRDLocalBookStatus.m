//
//  LocalBookStatus.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/25/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDLocalBookStatus.h"

@implementation BRDLocalBookStatus

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        //NSString* dateString = [aDecoder decodeObjectForKey:@"lastReadDate"];
        //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss a";
        self.lastReadDate = [aDecoder decodeObjectForKey:@"lastReadDate"]; //[dateFormatter dateFromString:dateString];
        self.pageLastRead = [[aDecoder decodeObjectForKey:@"pageLastRead"] intValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    /*
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    NSString* dateString = [dateFormatter stringFromDate:self.lastReadDate];*/
    [encoder encodeObject:self.lastReadDate forKey:@"lastReadDate"];
    [encoder encodeObject:[NSNumber numberWithInt:self.pageLastRead] forKey:@"pageLastRead"];
}
    
/*

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        NSString* dateString = [aDecoder decodeObjectForKey:@"lastReadDate"];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.lastReadDate = [dateFormatter dateFromString: dateString];
        self.pageLastRead = [[aDecoder decodeObjectForKey:@"pageLastRead"] intValue];
    }
    return self;
}
*/

@end
