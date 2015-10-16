//
//  LFAnnotation.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/9/15.

#import "SchoolMapAnnotation.h"

@implementation SchoolMapAnnotation

@synthesize coordinate, title, subtitle;

- (instancetype) initWithClassInfo: (SRXDataClassInfo*) classInfo {
    self = [super init];
    if (self) {
        self.coordinate = CLLocationCoordinate2DMake(classInfo.location.latitude, classInfo.location.longtitude);
        self.title = classInfo.summary;
        // TODO(liefuliu): set the subtitle.
        // self.subtitle = NSStringFromSRXDataClassTypeEnumSRXDataClassType(classInfo.classType);
        self.classInfo = classInfo;
    }
    return self;
}


@end
