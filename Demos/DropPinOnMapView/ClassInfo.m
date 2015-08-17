//
//  ClassInfo.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/16/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "ClassInfo.h"


@implementation ClassInfo


- (instancetype) initWithRandom: (CLLocationCoordinate2D) baseCoordinate {
    int random_x = arc4random();
    
    double x = (random_x % 20 - 10) * 0.001f;
    
    int random_y = arc4random();
    double y = (random_y % 20 - 10) * 0.0005f;
    
    baseCoordinate.longitude += x;
    baseCoordinate.latitude += y;
    
    return [self initAtCoordinate:baseCoordinate];
}

- (instancetype) initClassWithDescription: (NSString*) description
                             AtTime:(NSString*) time
                         AboutTopic:(NSString*) topic
                          WithPrice:(int) price
                         atLocation:(CLLocationCoordinate2D) locationCoordinate
                          atAddress:(NSString*) address {
    self = [super init];
    if (self) {
        //self.title = title;
        //self.description = description;
        self.time = time;
        self.topic = topic;
        self.price = price;
        self.locationCoordinate = locationCoordinate;
        self.address = address;
    }
    
    return self;
}


- (instancetype) initAtCoordinate: (CLLocationCoordinate2D) baseCoordinate {
    NSArray* arrayProject = @[@"围棋", @"舞蹈", @"美术", @"钢琴", @"书法", @"合唱"];
    NSString* topic = [arrayProject objectAtIndex: arc4random() % [arrayProject count]];
    
    NSArray* timeCandidates = @[@"每周一晚", @"每周二晚", @"每周二晚", @"每周四晚", @"每周六上午", @"每周六下午", @"每周六晚", @"每周日上午",@"每周日下午",@"每周日晚"];
    NSString* time = [timeCandidates objectAtIndex: arc4random() % [ timeCandidates count]];
    
    int price = (random() % 10 + 5) * 10;
    
    return [self initClassWithDescription:@"" AtTime:time AboutTopic:topic WithPrice:price atLocation:baseCoordinate atAddress:@""];

}

@end
