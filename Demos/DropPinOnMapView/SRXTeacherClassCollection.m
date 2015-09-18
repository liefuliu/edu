//
//  SRXTeacherClassCollection.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/6/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXTeacherClassCollection.h"


@interface SRXTeacherClassCollection ()
@property (readwrite) NSMutableArray* classCollection;
@end

@implementation SRXTeacherClassCollection


- (instancetype) init {
    self = [super init];
    if (self) {
        self.classCollection = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addClass: (ClassInfo*) classInfo {
   [self.classCollection addObject:classInfo];
}

+(SRXTeacherClassCollection* ) sharedClassCollectionForDemo {
    static SRXTeacherClassCollection* sharedClassCollection = nil;
    
    if (!sharedClassCollection) {
        sharedClassCollection = [[SRXTeacherClassCollection alloc] init];
        
        for (int i = 0; i < 3; i++) {
            CLLocationCoordinate2D randomCoordinate2D;
            ClassInfo* classInfo = [[ClassInfo alloc] initAtCoordinate:randomCoordinate2D];
            [sharedClassCollection addClass:classInfo];
        }
    }
    return sharedClassCollection;
}

@end
