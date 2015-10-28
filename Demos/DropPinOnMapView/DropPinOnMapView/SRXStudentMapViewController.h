//
//  MapViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/2/15.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SRXStudentMapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate,MKAnnotation, UISearchBarDelegate> {
    CLLocationManager *locationManager;
}


@property (strong, nonatomic) IBOutlet UISearchBar *searchBarTop;

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) IBOutlet UITextField *filterTopRight;


@end
