//
//  SRXStudentMapViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/2/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

//#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
   
// TODO(liefuliu): currently assume all iOS app are with version iOS 8.
#define IS_IOS8 YES

#import "SRXStudentMapViewController.h"
#import "CCLocationManager.h"
#import "ClassInfo.h"
#import "ClassesStore.h"
#import "LFAnnotation.h"
#import "DPMClassItemViewController.h"

@interface SRXStudentMapViewController () <CLLocationManagerDelegate> {
    CLLocationManager *locationmanager;
}
@end

@implementation SRXStudentMapViewController

/*(instancetype) init {
    self = [super init];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        // Create a new bar button item that will send
        // addNewItem: to BNRItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
}*/

- (void)viewDidLoad {
    NSLog(@"viewDidLoad started");
    
    [super viewDidLoad];
    
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
    
    [self performSelector:@selector(getLocation)];
    NSLog(@"viewDidLoad finished");
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"mapView didUpdateUserLocation");
    [self performSelector:@selector(getLocation)];
}


-(void)getLocation{
    NSLog(@"mapView getlocation");
    NSLog(@"%@", self.myMapView);
    __block __weak SRXStudentMapViewController *wself = self;
    
    if (IS_IOS8) {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            NSLog(@"getLocationCoordinate:%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            
            // Temporarily update the locaton to Zoom region
            MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(locationCorrrdinate, 2000, 2000);
            
            // Renders the map with region centered with user location.
            [self.myMapView setRegion:zoomRegion animated:YES];
            [self.myMapView setShowsUserLocation:YES];
            
            // Renders 15 random points nearby.
            for (int i = 0; i < 5; i++) {
                ClassInfo *classInfo = [[ClassInfo alloc] initWithRandom:locationCorrrdinate];
                
                LFAnnotation *randomNearbyAnnotation = [[LFAnnotation alloc] initWithClassInfo:classInfo];
                [self.myMapView addAnnotation:randomNearbyAnnotation];
            }
            
            for (NSString* key in [[ClassesStore sharedStore] allClasses]) {
                ClassInfo *classInfo = [[[ClassesStore sharedStore] allClasses] objectForKey: key];
                
                LFAnnotation *randomNearbyAnnotation = [[LFAnnotation alloc] initWithClassInfo:classInfo];
                [self.myMapView addAnnotation:randomNearbyAnnotation];

            }
        }];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // TODO(liefuliu): Not sure how this is used.
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"location manager granted");
    }
}


/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //[self performSegueWithIdentifier:@"DetailsIphone" sender:view];
    NSLog(@"calloutAccessoryControlTapped");
}*/


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = NO;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    /*
    DetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsPopover"];
    controller.annotation = view.annotation;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    self.popover.delegate = self;
    [self.popover presentPopoverFromRect:view.frame
                                  inView:view.superview
                permittedArrowDirections:UIPopoverArrowDirectionAny
                                animated:YES];*/
    NSLog(@"didSelectAnnotationView");
}


@end
