//
//  ClassesStore.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/16/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "ClassesStore.h"

@implementation ClassesStore

+ (instancetype) sharedStore {
    static ClassesStore* sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"User + [BNRImageStore sharedStore]" userInfo:nil];
    
    return nil;
}

- (instancetype) initPrivate {
    self = [super init];
    if (self) {
        _allClasses = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) setClass: (ClassInfo*) classInfo forKey:(NSString*) key {
    [_allClasses setObject:classInfo forKey:key];
}

@end
