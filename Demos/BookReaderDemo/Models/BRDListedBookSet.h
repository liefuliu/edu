//
//  BRDListedBookSet.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 9/1/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDListedBookSet : NSObject<NSCoding>

@property NSString* bookSetId;
@property NSString* bookSetName;
@property NSString* bookSetNotes;

- (id) initBookSet:(NSString*) bookSetId
           name:(NSString*) bookSetName
             notes:(NSString*) bookSetNotes;

@end