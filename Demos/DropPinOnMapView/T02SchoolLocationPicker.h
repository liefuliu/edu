//
//  T02SchoolLocationPicker.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 11/14/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCLocationManager.h"


@protocol T02SchoolLocationPickerDelegate <NSObject>
- (void) schoolLocationPicked:(CLLocationCoordinate2D) locationCoordinate;
@end


@interface T02SchoolLocationPicker : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic, weak) id delegate;

@end
