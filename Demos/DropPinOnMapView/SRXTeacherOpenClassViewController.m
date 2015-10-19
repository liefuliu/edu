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
#import "SRXClassUtil.h"
#import "SRXImage.h"

#import <MobileCoreServices/UTCoreTypes.h>

// TODO: Remove this once we created a location view.
#import "CCLocationManager.h"

@interface SRXTeacherOpenClassViewController () <CLLocationManagerDelegate, SRXSingleSelectionTableViewControllerDelegate> {
    CLLocationManager *locationmanager;
}


// TODO(liefuliu): refactor below 3 property into an image container.
// Contains all the images (of type SRXImage) including the '+' sign.
@property (nonatomic, strong) NSMutableArray *patternImagesArray;

// Contains the SRXImage from photo selection keyed by file name, doesn't include the '+' sign.
@property (nonatomic, strong) NSMutableDictionary *imageDictionary;

@property (nonatomic, strong) NSArray* rowKeys;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate2D;

@property (nonatomic) SRXDataClassTime* classTime;

// To be enabled: @property (nonatomic) SRXDataClassPrice* classPrice;
@property (nonatomic) SRXDataLocation* classLocation;

@property (nonatomic) SRXDataClassTypeEnumSRXDataClassType selectedClassType;

// All classes type which allow user to choose in SRXSingleSelectionViewController.
// All elements are in type of SRXDataClassTypeEnumSRXDataClassType.
@property (nonatomic) NSArray* classTypesAllowToSelect;

// Strings of all classes type which allow user to choose in SRXSingleSelectionViewController.
// All elements are in type of NSString*.
@property (nonatomic) NSArray* classTypeStringsAllowToSelect;

@property NSDictionary* classDescriptionDictionary;

@property (nonatomic) bool imagesUploadedToServer;

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
NSString* const plusSignFileName = @"plus_sign.png";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initializeItemsForSelection];
    
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = NSLocalizedString(@"New class", @"New class");
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(addNewClass:)];
    bbi.enabled = NO;
    navItem.rightBarButtonItem = bbi;
    
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
    self.patternImagesArray = [NSMutableArray arrayWithArray:@[plusSignFileName]];
    self.imageDictionary = [[NSMutableDictionary alloc ]init];
    
    SRXImage* srxImage = [[SRXImage alloc] initImage:[UIImage imageNamed:plusSignFileName] withFilename:plusSignFileName];
    [self.imageDictionary setObject:srxImage forKey:plusSignFileName];
    self.imagesUploadedToServer = NO;
    
    // Initialize the keys of rows.
    self.rowKeys = @[kTopicRowKey, kLocationRowKey, kPriceRowKey, kTimeRowKey];
    self.classDescriptionDictionary = [SRXClassUtil getClassDescriptiveDictionary];
    
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

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear: do something here");
    if ([self.imageDictionary count] > 1) {
        [self uploadImagesInBackground];
    }
}


-(void)dismissKeyboard {
    [self.classDescriptionTextField endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark helper function used by viewDidLoad

- (void) initializeItemsForSelection {
    [self initializeClassTypeItemsForSeletion];
}

- (void) initializeClassTypeItemsForSeletion {
    NSDictionary* dictionary = [SRXClassUtil getClassDescriptiveDictionary];
    self.classTypesAllowToSelect = [dictionary allKeys];
    self.classTypeStringsAllowToSelect = [dictionary allValues];
}



#pragma mark functions for adding image.

- (void) addImage:(NSString*) imageFileName {
    [self addImage:[UIImage imageNamed:imageFileName] forKey:imageFileName];
}

- (void) addImage: (UIImage*) imageData forKey:(NSString*) imageKey {
    if (![self.imageDictionary objectForKey:imageKey]) {
        [self.patternImagesArray insertObject:imageKey atIndex:self.patternImagesArray.count - 1];
        
        SRXImage* image = [[SRXImage alloc] initImage:imageData withFilename:imageKey];
        [self.imageDictionary setObject:image forKey:imageKey];
    }
}

#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection called");
    return self.rowKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath called");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell" ];
    }
    
    cell.textLabel.text = NSLocalizedString(self.rowKeys[indexPath.row], self.rowKeys[indexPath.row]);
    
    if (indexPath.row == kTopicRowIndex) {
        if (self.selectedClassType != SRXDataClassTypeEnumSRXDataClassTypeUnknown) {
            NSString* descriptiveText = [self.classDescriptionDictionary objectForKey:[NSNumber numberWithInt:self.selectedClassType]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", cell.textLabel.text, descriptiveText];
        }
    } else {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (indexPath.section == 0) {
         if (indexPath.row == 0) {
             SRXSingleSelectionTableViewController* selectionViewController = [[SRXSingleSelectionTableViewController alloc] initWithItems:self.classTypeStringsAllowToSelect];
             selectionViewController.delegate = self;
             [self presentViewController:selectionViewController animated:YES completion:nil];
         } else {
             // TODO(fengyi): Handle the touch event on "学费" and "时间"
             // Currently we only allow the teacher to select "科目"， we need to eanble
             // the similar logic to allow teacher to select "学费" and "时间".
         }
     }
     
 }

- (void) itemDidSelectAt: (int) selectedIndex
             withContent: (NSString*) selectedItem {
    NSLog(@"SelectedItem: %@", selectedItem);
    
    self.selectedClassType = (SRXDataClassTypeEnumSRXDataClassType)[self.classTypesAllowToSelect[selectedIndex] intValue];
    [self.classInfoTableView reloadData];
    
}

#pragma mark Logic related to Topic row.

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
    SRXImage* srxImage =((SRXImage*)[self.imageDictionary objectForKey:self.patternImagesArray[indexPath.row]]);
    cell.image = srxImage.image;
    
    if (self.patternImagesArray[indexPath.row] == plusSignFileName) {
        cell.progressBar.hidden = YES;
    } else {
        cell.progressBar.hidden = NO;

        if (srxImage.uploaded) {
            cell.progressBar.progress = 1.0;
        } else {
            cell.progressBar.progress = 0.0;
        }
    }
    
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
        SRXImage* srxImage = [self.imageDictionary objectForKey:self.patternImagesArray[indexPath.row]];
        SRXImageViewController* imageViewController = [[SRXImageViewController alloc] initWithImage:[srxImage image]];
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
    
    self.imagesUploadedToServer = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
   // [self uploadImagesInBackground];
    
}

- (void) elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark functions for adding a new class.

// Check whether all the necessary info haven't been filed. Throw an alert and return false
// if not.
- (BOOL) qualifedForAddNewClass {
    if ([self.classDescriptionTextField.text length] == 0) {
        [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
             withDetail:NSLocalizedString(@"Class summary must be filled", nil)];
        return NO;
    }
    
    if (self.selectedClassType == SRXDataClassTypeEnumSRXDataClassTypeUnknown) {
        [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
             withDetail:NSLocalizedString(@"Class type wasn't set", nil)];
        return NO;
    }
    
    if ([self.imageDictionary count] <= 1) {
        [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
             withDetail:NSLocalizedString(@"No images are selected", nil)];
        return NO;
    }
    
    /*
    if (self.classTime == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error creating a new class", nil)
                                                        message:NSLocalizedString(@"Class time wasn't set.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }*/
    
    return YES;
}

- (void) addNewClassWithImageKeys {
    SRXDataClassInfoBuilder* classInfoBuilder = [SRXDataClassInfo builder];
    [classInfoBuilder setSummary:self.classDescriptionTextField.text];
    [classInfoBuilder setLocationBuilder:
     [[[SRXDataLocation builder] setLatitude:_locationCoordinate2D.latitude] setLongtitude:_locationCoordinate2D.longitude]];
    [classInfoBuilder setClassType: self.selectedClassType];
    
    // Add new images.
    [self.imageDictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ((NSString*) key != plusSignFileName) {
            // Update the image to server as file.
            SRXImage* image = (SRXImage*) obj;
            NSAssert(image.uploaded, @"Exception: image is expected to be uploaded already.");
            
            // Ideally the view controller shouldn't know which server the backend is using.
            SRXDataImageRef* imageRef = [[[[SRXDataImageRef builder] setServerType:SRXDataImageServerTypeEnumImageServerTypeParse] setImageKey:image.serverKey] build];
            [classInfoBuilder addImageRef:imageRef];
        }
    }];

    
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
                                           [self.navigationController popViewControllerAnimated:YES];
                                           if([self.delegate respondsToSelector:@selector(newClassCreated)]) {
                                               [self.delegate newClassCreated];
                                           }
                                       } else {
                                           [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
                                                withDetail:NSLocalizedString(@"Failed to updte class info", nil)];
                                       }
                                   }];
}

- (IBAction)addNewClass:(id)sender {
    if (![self qualifedForAddNewClass]) {
        return;
    }
    
    [self addNewClassWithImageKeys];
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

# pragma auxiluary functions.

- (void) showAlert:(NSString*) title
        withDetail:(NSString*) detail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:  title
                                                    message:detail
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
    [alert show];
}

- (void) uploadImagesInBackground {
    SRXProtoAddImagesRequestBuilder* requestBuilder = [SRXProtoAddImagesRequest builder];
    
    NSMutableArray* imagesToUpload = [[NSMutableArray alloc] init];
    [self.imageDictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ((NSString*) key != plusSignFileName) {
            // Update the image to server as file.
            SRXImage* image = (SRXImage*) obj;
            if (!image.uploaded) {
                SRXProtoImage* protoImage = [[[SRXProtoImage builder] setData:UIImageJPEGRepresentation(image.image, 0.8)] build];
                NSLog(@"image size: %.2f KB", [[protoImage data] length] / 1024.0);
                [requestBuilder addImage:protoImage];
                [imagesToUpload addObject:image];
            }
        }
    }];
    
    __block SRXProtoAddImagesResponseBuilder* responseBuilder = [SRXProtoAddImagesResponse builder];
    __block SRXProtoAddImagesRequest* request = [requestBuilder build];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    dispatch_async(queue, ^{
    [[SRXApiFactory getActualApi] addImages: request
                               withResponse: &responseBuilder
                                 completion:^(BOOL success, NSString* errorMsg) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         SRXProtoAddImagesResponse* addImagesResponse = [responseBuilder build];
                                         if (success) {
                                             // Upload succeeded, so update the
                                             // server key for each uploaded image.
                                             if ([imagesToUpload count] != [[addImagesResponse imageKey] count]) {
                                                NSLog(@"Images to upload in the request doesn't match with the response. Requested: %d, Responded: %d",
                                                      [imagesToUpload count],
                                                      [[addImagesResponse imageKey] count]);
                                                 [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
                                                    withDetail:NSLocalizedString(@"Failed to upload images", nil)];
                                                 return;
                                                 
                                             }
                                             
                                             NSAssert([imagesToUpload count] == [[addImagesResponse imageKey] count], @"");
                                             
                                             for (int i = 0; i < [imagesToUpload count]; i++) {
                                                 SRXImage* image = imagesToUpload[i];
                                                 NSString* serverKey = addImagesResponse.imageKey[i];
                                                 [image MarkAsUploadedWithServerKey:serverKey];
                                             }
                                             self.navigationItem.rightBarButtonItem.enabled = YES;
                                             [self.view setNeedsDisplay];
                                             [self.photoCollectionView reloadData];
                                         } else {
                                             [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
                                                  withDetail:NSLocalizedString(@"Failed to upload images", nil)];
                                         }
                                         
                                     });
                                 }];
    });
    
}

@end
