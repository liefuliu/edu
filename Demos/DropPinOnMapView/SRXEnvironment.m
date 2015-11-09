//
//  SRXEnvironment.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 11/8/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXEnvironment.h"

@implementation SRXEnvironment

+ (id)sharedObject {
    static SRXEnvironment *sharedEnvironment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEnvironment = [[self alloc] init];
    });
    return sharedEnvironment;
}

- (id)init {
    if (self = [super init]) {
        self.startingMode = SRXStartingModeStudent;
    }
    return self;
}


@end
