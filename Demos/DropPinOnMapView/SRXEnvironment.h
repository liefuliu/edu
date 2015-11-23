//
//  SRXEnvironment.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 11/8/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRXEnvironment : NSObject


typedef NS_ENUM(NSInteger, SRXStartingMode) {
    SRXStartingModeStudent,
    SRXStartingModeTeacher
};

@property SRXStartingMode startingMode;

+ (id) sharedObject;

@end
