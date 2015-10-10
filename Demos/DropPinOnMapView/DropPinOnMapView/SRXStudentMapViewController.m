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
#import "SRXStudentClassViewController.h"
#import "CCLocationManager.h"
#import "ClassInfo.h"
#import "ClassesStore.h"
#import "LFAnnotation.h"
#import "DPMClassItemViewController.h"
#import "SRXDataClass.pb.h"
#import "SRXApiFactory.h"

@interface SRXStudentMapViewController () <CLLocationManagerDelegate> {
    CLLocationManager *locationmanager;
}
@property NSArray* nearByClasses;

@end

@implementation SRXStudentMapViewController

- (void)viewDidLoad {
    NSLog(@"SRXStudentMapViewController viewDidLoad started");
    
    [super viewDidLoad];
    
    self.myMapView.delegate = self;
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

/*

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
    
    [self performSelector:@selector(getLocation)];
    NSLog(@"viewWillAppear finished");
}*/

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
            /*
            for (int i = 0; i < 5; i++) {
                ClassInfo *classInfo = [[ClassInfo alloc] initWithRandom:locationCorrrdinate];
                
                LFAnnotation *randomNearbyAnnotation = [[LFAnnotation alloc] initWithClassInfo:classInfo];
                [self.myMapView addAnnotation:randomNearbyAnnotation];
            }*/
            
            
            SRXProtoSearchClassRequestBuilder* requestBuilder = [SRXProtoSearchClassRequest builder];
            [requestBuilder setLatitude:locationCorrrdinate.latitude];
            [requestBuilder setLongtitude:locationCorrrdinate.longitude];
            
            SRXProtoSearchClassRequest* request = [requestBuilder build];
            SRXProtoSearchClassResponseBuilder* responseBuilder = [SRXProtoSearchClassResponse builder];
            
            [[SRXApiFactory getActualApi] searchClass: request
                                       withResponse:&responseBuilder completion:^(BOOL success, NSString* errorMsg) {
                                           if (success) {
                                               SRXProtoSearchClassResponse* response = [responseBuilder build];
                                               self.nearByClasses = [response classCollection];
                                               [self updateMapWithNearByClasses];
                                               NSLog(@"Successfully retrieved allClasses: %@", self.nearByClasses);
                                           } else {
                                               // DO nothing
                                               NSLog(@"Cannot read class");
                                           }
                                           
                                       }];

            /*
            for (NSString* key in [[ClassesStore sharedStore] allClasses]) {
                ClassInfo *classInfo = [[[ClassesStore sharedStore] allClasses] objectForKey: key];
                
                LFAnnotation *randomNearbyAnnotation = [[LFAnnotation alloc] initWithClassInfo:classInfo];
                [self.myMapView addAnnotation:randomNearbyAnnotation];
            }*/
        }];
    }
    
}

- (void) updateMapWithNearByClasses {
    [self removeAllPinsButUserLocation];
    for(SRXDataClassInfo* classInfo in self.nearByClasses) {
        // LFAnnotation*
        LFAnnotation *nearByAllocation = [[LFAnnotation alloc] initWithClassInfo:classInfo];
        [self.myMapView addAnnotation:nearByAllocation];
    }
}

- (void)removeAllPinsButUserLocation
{
    id userLocation = [self.myMapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.myMapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self.myMapView removeAnnotations:pins];
    pins = nil;
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

/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = NO;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    NSLog(@"didSelectAnnotationView");
}
*/

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    /*
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    
UIButton * disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
[disclosureButton addTarget:self
                     action:@selector(presentMoreInfo)
           forControlEvents:UIControlEventTouchUpInside];
annotationView.rightCalloutAccessoryView = disclosureButton;
    */

    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // If it is our ShopAnnotation, we create and return its view
    if ([annotation isKindOfClass:[LFAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString* shopAnnotationIdentifier = @"ShopAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:shopAnnotationIdentifier ];
        if (!pinView) {
            // If an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:shopAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        } else {
            pinView.annotation = annotation;
        }
    
        return pinView;
    }
    return nil;
}


- (void)mapView:(MKMapView *)map annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"Annotation clicked");
    
    //SRXStudentClassViewController* classViewController = [[SRXStudentClassViewController alloc] init];
    //[self presentViewController:classViewController animated:YES completion:nil];
    
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SRXStudentClassViewController* customViewController = (SRXStudentClassViewController*)[tableViewStoryboard instantiateViewControllerWithIdentifier:@"student class view"];
    
    LFAnnotation *annotation = view.annotation;
    SRXDataClassInfo* classInfo = [annotation classInfo];
    [customViewController setClassInfo:classInfo];
    [self.navigationController pushViewController:customViewController animated:YES];
}



- (void)presentMoreInfo {
    NSLog(@"presentMoreInfo called");
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"regionDidChangeAnimated");
    //[self performSelector:@selector(getLocation)];
}


-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"StudentMapViewController viewDidDisappear");
    [super viewDidDisappear:animated];
    //[self purgeMapMemory];
}

// This is for a bug in MKMapView for iOS6
// Try to purge some of the memory being allocated by the map
/*
- (void)purgeMapMemory
{
    // Switching map types causes cache purging, so switch to a different map type
    self.myMapView.mapType = MKMapTypeStandard;
    [self.myMapView removeFromSuperview];
    self.myMapView = nil;
}
*/
@end
