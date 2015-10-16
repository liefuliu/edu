//
//  LFAnnotation.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/9/15.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "SRXDataClass.pb.h"

@interface SchoolMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) SRXDataClassInfo* classInfo;

// Create a annotation at a random nearby coordinate to 'baseCoordinate', and with
// random edu information.
- (instancetype) initWithCoordinate: (CLLocationCoordinate2D) baseCoordinate;

- (instancetype) initWithClassInfo: (SRXDataClassInfo*) classInfo;
@end
