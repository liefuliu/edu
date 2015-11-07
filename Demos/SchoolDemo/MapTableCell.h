//
//  MapTableCell.h
//  SchoolDemo
//
//  Created by Liefu Liu on 11/1/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(void) setPin:(CLLocationCoordinate2D) locationCoordinate;

@end
