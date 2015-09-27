//
//  SRXApiFactory.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/25/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXApiFactory.h"
#import "SRXParseApi.h"

@implementation SRXApiFactory
+(id) getActualApi {
    return [SRXParseApi sharedObject];
}
@end
