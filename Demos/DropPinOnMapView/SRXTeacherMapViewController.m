//
//  SRXStudentMapViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/2/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

// #define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

// TODO(liefuliu): currently assume all iOS app are with version iOS 8.
#define IS_IOS8 YES

#import "SRXTeacherMapViewController.h"
#import "CCLocationManager.h"
#import "LFAnnotation.h"
#import "DPMClassItemViewController.h"

#import "ClassesStore.h"
#import "ClassInfo.h"

@interface SRXTeacherMapViewController () <CLLocationManagerDelegate> {
    CLLocationManager *locationmanager;
}
@end

@implementation SRXTeacherMapViewController
- (instancetype) init {
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
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad started");
    
    [super viewDidLoad];
    
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    // Create a gesture recognizer for long presses (for example in viewDidLoad)
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //user needs to press for half a second.
    [self.myMapView addGestureRecognizer:lpgr];
    
    
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
    
    [self performSelector:@selector(getLocation)];
    
    [self updateMapView];
    NSLog(@"viewDidLoad finished");
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"mapView didUpdateUserLocation");
    [self performSelector:@selector(getLocation)];
}


-(void)getLocation{
    NSLog(@"mapView getlocation");
    __block __weak SRXTeacherMapViewController *wself = self;
    
    if (IS_IOS8) {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            
            // Temporarily update the locaton to Zoom region
            MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(locationCorrrdinate, 2000, 2000);
            
            // Renders the map with region centered with user location.
            [self.myMapView setRegion:zoomRegion animated:YES];
            [self.myMapView setShowsUserLocation:YES];
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

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [gestureRecognizer locationInView:self.myMapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.myMapView convertPoint:touchPoint toCoordinateFromView:self.myMapView];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = touchMapCoordinate;
    
    /*
     for (id annotation in self.myMapView.annotations) {
     [self.myMapView removeAnnotation:annotation];
     }*/
    
    DPMClassItemViewController *detailViewController = [[DPMClassItemViewController alloc] init];
    
    
    //NSArray *items = [[BNRItemStore sharedStore] allItems];
    //BNRItem *selectedItem = items[indexPath.row];
    
    // Give detail view controller a pointer to the item object in row
    //detailViewController.item = selectedItem;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
    
    
    //[self.myMapView addAnnotation:point];
    
    ClassesStore* sharedStore = [ClassesStore sharedStore];
    ClassInfo* newClass = [[ClassInfo alloc] initAtCoordinate:point.coordinate];
    
    NSUUID* uuid = [[NSUUID alloc] init];
    NSString* key = [uuid UUIDString];
    [sharedStore setClass:newClass forKey:key];
    
    [self updateMapView];
}

- (void) updateMapView {
    for (NSString* key in [[ClassesStore sharedStore] allClasses]) {
        ClassInfo *classInfo = [[[ClassesStore sharedStore] allClasses] objectForKey: key];
        
        LFAnnotation *randomNearbyAnnotation = [[LFAnnotation alloc] initWithClassInfo:classInfo];
        [self.myMapView addAnnotation:randomNearbyAnnotation];
        
    }
}

@end
