//
//  T02SchoolLocationPicker.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 11/14/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "T02SchoolLocationPicker.h"


#define IS_IOS8 YES

@interface T02SchoolLocationPicker () <CLLocationManagerDelegate> {
    CLLocationManager *locationmanager;
}

@property CLLocationCoordinate2D selectedLocation;

@end

@implementation T02SchoolLocationPicker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = NSLocalizedString(@"Long touch school location", nil);
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(schoolAddressPicked:)];
    bbi.enabled = NO;
    navItem.rightBarButtonItem = bbi;
    
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
    
    [self performSelector:@selector(getLocation)];
    
    
    // Create a gesture recognizer for long presses (for example in viewDidLoad)
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //user needs to press for half a second.
    [self.myMapView addGestureRecognizer:lpgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)schoolAddressPicked:(id)sender {
    /*
    if (![self qualifedForAddNewClass]) {
        return;
    }
    
    [self addNewClassWithImageKeys];*/
    
    
    if([self.delegate respondsToSelector:@selector(schoolLocationPicked:)]) {
        [self.delegate schoolLocationPicked:self.selectedLocation];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getLocation{
    NSLog(@"mapView getlocation");
    NSLog(@"%@", self.myMapView);
    __block __weak T02SchoolLocationPicker *wself = self;
    
    if (IS_IOS8) {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            NSLog(@"getLocationCoordinate:%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            
            // Temporarily update the locaton to Zoom region
            MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(locationCorrrdinate, 2000, 2000);
            
            // Renders the map with region centered with user location.
            [self.myMapView setRegion:zoomRegion animated:YES];
            [self.myMapView setShowsUserLocation:YES];
            
        }];
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
    _selectedLocation = point.coordinate;
    for (id annotation in self.myMapView.annotations) {
        [self.myMapView removeAnnotation:annotation];
    }
    [self.myMapView addAnnotation:point];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
