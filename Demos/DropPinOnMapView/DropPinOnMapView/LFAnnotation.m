//
//  LFAnnotation.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/9/15.

#import "LFAnnotation.h"
#import "ClassInfo.h"

@implementation LFAnnotation

@synthesize coordinate, title, subtitle;

- (instancetype) initWithClassInfo: (ClassInfo*) classInfo {
    self = [super init];
    if (self) {
        self.coordinate = classInfo.locationCoordinate;
        self.title = classInfo.topic;
        self.subtitle = [NSString stringWithFormat:@"%@，%d 元/次", classInfo.time , classInfo.price];
    }
    return self;
}

@end
