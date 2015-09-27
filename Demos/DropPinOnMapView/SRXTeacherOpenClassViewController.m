//
//  SRXTeacherOpenClassViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/7/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "SRXTeacherOpenClassViewController.h"
#import "SRXPhotoCell.h"
#import "SRXImageViewController.h"
#import "SRXApiFactory.h"
#import "SRXSingleSelectionTableViewController.h"

#import "SRXDataClass.pb.h"

#import <MobileCoreServices/UTCoreTypes.h>


// TODO: Remove this once we created a location view.
#import "CCLocationManager.h"


@interface SRXTeacherOpenClassViewController () <CLLocationManagerDelegate> {
    CLLocationManager *locationmanager;
}

//@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSMutableArray *patternImagesArray;
@property (nonatomic, strong) NSMutableDictionary *imageDictionary;
@property (nonatomic, strong) NSArray* rowKeys;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate2D;

@end

@implementation SRXTeacherOpenClassViewController

#pragma constants

const int kTopicRowIndex = 0;
const int kLocationRowIndex = 1;
const int kPriceRowIndex = 2;
const int kTimeRowIndex = 3;

NSString* const kTopicRowKey = @"Topic";
NSString* const kLocationRowKey = @"Location";
NSString* const kPriceRowKey = @"Price";
NSString* const kTimeRowKey = @"Time";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = NSLocalizedString(@"New class", @"New class");
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(addNewClass:)];
    navItem.rightBarButtonItem = bbi;
    // navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
    
    
    // Initialize the table view of class info.
    self.classInfoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.classInfoTableView.delegate = self;
    self.classInfoTableView.dataSource = self;
    
    // Initialize the table view of class info.
    [self.classInfoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"SRXPhotoCell" bundle:nil];
    [self.photoCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    // Initialize the class image array.
    NSString* const plusSignFileName = @"plus_sign.png";
    self.patternImagesArray = [NSMutableArray arrayWithArray:@[plusSignFileName]];
    self.imageDictionary = [[NSMutableDictionary alloc ]init];
    [self.imageDictionary setObject:[UIImage imageNamed:plusSignFileName] forKey:plusSignFileName];
    
    // Initialize the keys of rows.
    self.rowKeys = @[kTopicRowKey, kLocationRowKey, kPriceRowKey, kTimeRowKey];
    
    [self.classDescriptionTextField becomeFirstResponder];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    if (YES) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
        
        [self performSelector:@selector(getLocation)];
    }
}

-(void)dismissKeyboard {
    [self.classDescriptionTextField endEditing:YES];
    
    /* Junk: DO NOT SUBMIT
     MyClassInfo* person = [[[MyClassInfo builder] setDescription:@"hello world"]build];
     SRXDataClassInfo * newClass = [[[[SRXDataClassInfo builder] setId:32] setClassInfo:person] build];
     NSLog(@"ClassInfo: %@", newClass);*/
}

- (void) addImage:(NSString*) imageFileName {
    [self addImage:[UIImage imageNamed:imageFileName] forKey:imageFileName];
}

- (void) addImage: (UIImage*) image forKey:(NSString*) imageKey {
    if (![self.imageDictionary objectForKey:imageKey]) {
        [self.patternImagesArray insertObject:imageKey atIndex:self.patternImagesArray.count - 1];
        [self.imageDictionary setObject:image forKey:imageKey];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection called");
    return self.rowKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath called");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(self.rowKeys[indexPath.row], self.rowKeys[indexPath.row]);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     /*
 if (indexPath.section == 0) {
 
 } else if (indexPath.section == 1){
 SRXTeacherOpenClassViewController *detailViewController = [[SRXTeacherOpenClassViewController alloc] init];
 
 // Push it onto the top of the navigation controller's stack
 [self.navigationController pushViewController:detailViewController
 animated:YES];
 }*/
     if (indexPath.section == 0) {
         if (indexPath.row == 0) {
             SRXSingleSelectionTableViewController* selectionViewController = [[SRXSingleSelectionTableViewController alloc] initWithItems:@[
             @"语文", @"数学"]];
             selectionViewController.delegate = self;
             [self presentViewController:selectionViewController animated:YES completion:nil];
         }
     }
     
 }


- (void) itemDidSelectAt: (int) selectedIndex
             withContent: (NSString*) selectedItem {
    NSLog(@"SelectedItem: %@", selectedItem);
    
}

#pragma mark Logic related to Topic row.
/*
 - (void) rowTopicTapped {
 
 }
 
 - (void) (ClassTopicPickerViewController *)picker
 didFinishPickingMediaWithInfo:(NSArray *)info {
 
 }*/

// TODO(liefuliu): implement a generic 1-out-of-N table view.

// TODO(liefuliu): implement a comlete button and the delegate back the info.




#pragma mark UICollectionViewDelegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.patternImagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SRXPhotoCell *cell = (SRXPhotoCell *)[collectionView
                                          dequeueReusableCellWithReuseIdentifier:@"cvCell"
                                          forIndexPath:indexPath];
    
    cell.image = [self.imageDictionary objectForKey:self.patternImagesArray[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50.0, 50.0);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}


- (void) collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.patternImagesArray.count - 1) {
        NSLog(@"Pick additional photos");
        [self buttonAddPhotoTapped];
    } else {
        SRXImageViewController* imageViewController = [[SRXImageViewController alloc] init];
        imageViewController.image = [self.imageDictionary objectForKey:self.patternImagesArray[indexPath.row]];;
        [self.navigationController pushViewController:imageViewController animated:YES];
    }
}

- (void) buttonAddPhotoTapped {
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker
   didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                NSString* assetURL = [dict objectForKey:UIImagePickerControllerReferenceURL];
                NSLog(@"assetURL selected: %@", assetURL);
                
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:assetURL
                               resultBlock:^(ALAsset *myasset){
                                   ALAssetRepresentation *rep = [myasset defaultRepresentation];
                                   @autoreleasepool {
                                       CGImageRef iref = [rep fullScreenImage];
                                       if (iref) {
                                           NSLog(@"Add image URL: %@", assetURL);
                                           UIImage *image = [UIImage imageWithCGImage:iref];
                                           [self addImage:image forKey:assetURL];
                                           
                                           // TODO(liefuliu): What is this doing?
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               //UIMethod trigger...
                                           });
                                           iref = nil;
                                       }
                                   }
                               }
                              failureBlock:nil];
                
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            // Video Asset is not supported for now.
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    [self.photoCollectionView reloadData];
}

- (void) elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark

- (IBAction)addNewClass:(id)sender {
    SRXDataClassInfoBuilder* classInfoBuilder = [SRXDataClassInfo builder];
    [classInfoBuilder setSummary:self.classDescriptionTextField.text];
    [classInfoBuilder setLocationBuilder:
     [[[SRXDataLocation builder] setLatitude:_locationCoordinate2D.latitude] setLongtitude:_locationCoordinate2D.longitude]];
    // TODO: add more info about the class
    
    SRXProtoCreateClassRequestBuilder* createClassRequestBuilder = [SRXProtoCreateClassRequest builder];
    [createClassRequestBuilder setClassInfoBuilder:classInfoBuilder];
    
    SRXProtoCreateClassRequest* createClassRequest = [createClassRequestBuilder build];
    
    NSLog(@"Create class request: %@", createClassRequest);
    // TODO: add more info about the class.
    
    SRXProtoCreateClassResponse* createClassResponse;
    [[SRXApiFactory getActualApi] createClass:createClassRequest withResponse:&createClassResponse
                                   completion:^(BOOL success, NSString* errorMsg) {
                                       if (success) {
                                           _classInfo = [createClassRequest classInfo];
                                           NSLog(@"Class info: %@", _classInfo);
                                           if([self.delegate respondsToSelector:@selector(newClassCreated:)]) {
                                               [self.delegate newClassCreated];
                                           }
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }
                                   }];
}


-(void)getLocation{
    NSLog(@"mapView getlocation");
    __block __weak SRXTeacherOpenClassViewController *wself = self;
    
    if (YES) {
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            NSLog(@"getLocationCoordinate:%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            _locationCoordinate2D = locationCorrrdinate;
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


@end
