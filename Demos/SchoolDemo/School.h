//
//  School.h
//  SchoolDemo
//
//  Created by Liefu Liu on 10/31/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface School : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* description;
@property (nonatomic) NSString* address;
@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property (nonatomic) NSArray* imageArray;

@end
