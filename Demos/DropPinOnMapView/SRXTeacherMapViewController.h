//
//  MapViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/2/15.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SRXTeacherMapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate,MKAnnotation> {
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;


- (instancetype) init;

@end
