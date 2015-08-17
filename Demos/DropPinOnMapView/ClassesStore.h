//
//  ClassesStore.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/16/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassInfo.h"

@interface ClassesStore : NSObject

// TODO(liefuliu): convert to an NSDictionary*.
@property (nonatomic) NSMutableDictionary* allClasses;

- (void) setClass: (ClassInfo*) classInfo forKey:(NSString*) key;


+ (instancetype) sharedStore;

@end
