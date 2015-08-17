//
//  ClassInfo.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/16/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface ClassInfo : NSObject

// Static class properties.
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* description;
@property (readwrite, nonatomic, strong) NSString* time;
@property (readwrite, nonatomic, strong) NSString* topic;
@property (nonatomic) int price;
@property (nonatomic) int minimumStudents;
@property (nonatomic) int maxStudents;
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic) NSString* address;

// Dynamic class properties.


- (instancetype) initWithRandom: (CLLocationCoordinate2D) baseCoordinate;

- (instancetype) initClassWithTitle:(NSString*) title
                    WithDescription: (NSString*) description
                             AtTime:(NSString*) time
                         AboutTopic:(NSString*) topic
                          WithPrice:(int) price
                         atLocation:(CLLocationCoordinate2D) locationCoordinate
                          atAddress:(NSString*) address;

- (instancetype) initAtCoordinate: (CLLocationCoordinate2D) baseCoordinate;

@end
