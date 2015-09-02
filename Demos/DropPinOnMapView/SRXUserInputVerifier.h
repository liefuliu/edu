//
//  SRXUserInputVerifier.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/30/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRXUserInputVerifier : NSObject

+ (BOOL) mightBeValidPassword: (NSString*) text;
+ (BOOL) mightBeValidEmail: (NSString*) text;
+ (BOOL) mightBeValidPersonName: (NSString*) text;

@end
