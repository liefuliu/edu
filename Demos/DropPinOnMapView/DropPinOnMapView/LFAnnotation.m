//
//  LFAnnotation.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/9/15.

#import "LFAnnotation.h"

@implementation LFAnnotation

@synthesize coordinate, title, subtitle;


- (instancetype) initWithCoordinate: (CLLocationCoordinate2D) baseCoordinate {
    self = [super init];
    
    if (self) {
        int random_x = arc4random();
        
        double x = (random_x % 20 - 10) * 0.001f;
        
        int random_y = arc4random();
        double y = (random_y % 20 - 10) * 0.0005f;
        
        coordinate.longitude = baseCoordinate.longitude + x;
        coordinate.latitude = baseCoordinate.latitude + y;

        NSArray* arrayProject = @[@"围棋", @"舞蹈", @"美术", @"钢琴", @"书法", @"合唱"];
        title = [arrayProject objectAtIndex: arc4random() % [arrayProject count]];
        
        NSArray* timeCandidates = @[@"每周一晚", @"每周二晚", @"每周二晚", @"每周四晚", @"每周六上午", @"每周六下午", @"每周六晚", @"每周日上午",@"每周日下午",@"每周日晚"];
        NSString* time = [timeCandidates objectAtIndex: arc4random() % [ timeCandidates count]];
        
        int price = (random() % 10 + 5) * 10;
        subtitle = [NSString stringWithFormat:@"%@，%d 元/次", time , price];
    }
    
    return self;
}

@end
