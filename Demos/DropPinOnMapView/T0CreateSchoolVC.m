//
//  T0CreateSchoolVC.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 11/11/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "T0CreateSchoolVC.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>

#import "ELCimagePickerHeader.h"
#import "SRXPhotoCell.h"
#import "SRXImageViewController.h"
#import "SRXApiFactory.h"
#import "SRXSingleSelectionTableViewController.h"
#import "SRXDataClass.pb.h"
#import "SRXClassUtil.h"
#import "SRXImage.h"
#import "UIViewController+Charleene.h"

#import "T01SchoolDescriptionVC.h"
#import "T02SchoolLocationPicker.h"

@interface T0CreateSchoolVC () <CLLocationManagerDelegate> {
    CLLocationManager *locationmanager;
}

// TODO(liefuliu): refactor below 2 property into an image container.
// Contains all the images (of type SRXImage) including the '+' sign.
@property (nonatomic, strong) NSMutableArray *patternImagesArray;

// Contains the SRXImage from photo selection keyed by file name, doesn't include the '+' sign.
@property (nonatomic, strong) NSMutableDictionary *imageDictionary;

@property (nonatomic, strong) NSArray* rowKeys;

@property (nonatomic) bool imagesUploadedToServer;

@property NSString* schoolDescription;

@property SRXDataLocation* schoolLocation;

@end

@implementation T0CreateSchoolVC

static const int kDescriptionRowIndex = 0;
//static const int kTopicRowIndex = 1;
static const int kLocationRowIndex = 1;

static NSString* const kDescriptionKey = @"School Description";
//static NSString* const kTopicRowKey = @"Topic";
static NSString* const kLocationRowKey = @"Location";

static NSString* const plusSignFileName = @"plus_sign.png";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = NSLocalizedString(@"New school", @"New school");
    // Do any additional setup after loading the view from its nib.
    
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(addNewClass:)];
    bbi.enabled = NO;
    navItem.rightBarButtonItem = bbi;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    // Initialize the table view of class info.
    self.infoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    
    // Initialize the table view of class info.
    
    [self.infoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"SRXPhotoCell" bundle:nil];
    [self.photoCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    // Initialize the school info.
    _schoolDescription = nil;
    _schoolLocation = nil;
    
    // Initialize the class image array.
    self.patternImagesArray = [NSMutableArray arrayWithArray:@[plusSignFileName]];
    self.imageDictionary = [[NSMutableDictionary alloc ]init];
    
    SRXImage* srxImage = [[SRXImage alloc] initImage:[UIImage imageNamed:plusSignFileName] withFilename:plusSignFileName];
    [self.imageDictionary setObject:srxImage forKey:plusSignFileName];
    self.imagesUploadedToServer = NO;
    
    // Initialize the keys of rows.
    self.rowKeys = @[kDescriptionKey, kLocationRowKey];
    
    [self.schoolNameTextField becomeFirstResponder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear: do something here");
    if ([self.imageDictionary count] > 1) {
        [self uploadImagesInBackground];
    }
}


-(void)dismissKeyboard {
    [self.schoolNameTextField endEditing:YES];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"UITableViewCell" ];
    }
    /*
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell" ];
    */
     
    cell.textLabel.text = NSLocalizedString(self.rowKeys[indexPath.row], self.rowKeys[indexPath.row]);
    if (indexPath.row == kLocationRowIndex) {
        if (_schoolLocation != nil) {
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:NSLocalizedString(@" (been set)", nil)];
            
        }
    } else if (indexPath.row == kDescriptionRowIndex) {
        if (_schoolDescription != nil) {
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:NSLocalizedString(@" (been set)", nil)];


        }
    }
    /* Temporarily disable the top row selection.
     if (indexPath.row == kTopicRowIndex) {
     if (self.selectedClassType != SRXDataClassTypeEnumSRXDataClassTypeUnknown) {
     NSString* descriptiveText = [self.classDescriptionDictionary objectForKey:[NSNumber numberWithInt:self.selectedClassType]];
     cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", cell.textLabel.text, descriptiveText];
     }
     } else {
     }*/
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        /* Temporarily disable the Topic item in table
         if (indexPath.row == kTopicRowIndex) {
         SRXSingleSelectionTableViewController* selectionViewController = [[SRXSingleSelectionTableViewController alloc] initWithItems:self.classTypeStringsAllowToSelect];
         selectionViewController.delegate = self;
         [self presentCharleeneModally:selectionViewController transitionMode:KSModalTransitionModeFromBottom];
         } else*/
        if (indexPath.row == kDescriptionRowIndex){
            T01SchoolDescriptionVC* vc = [[T01SchoolDescriptionVC alloc] init];
            if (_schoolDescription) {
                [vc setDescriptionText:_schoolDescription];
            }
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == kLocationRowIndex) {
            T02SchoolLocationPicker* vc = [[T02SchoolLocationPicker alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            //[self presentCharleeneModally:vc transitionMode:KSModalTransitionModeFromBottom];
        } else {
            // Ignore it for now...
        }
    }
    
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
- (BOOL) qualifedForAddNewSchool {
    if ([self.schoolNameTextField.text length] == 0) {
        [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
             withDetail:NSLocalizedString(@"Class summary must be filled", nil)];
        return NO;
    }
    
    if ([self.imageDictionary count] <= 1) {
        [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
             withDetail:NSLocalizedString(@"No images are selected", nil)];
        return NO;
    }
    
    if (_schoolDescription == nil || _schoolDescription.length == 0) {
        [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
             withDetail:NSLocalizedString(@"Summary of school has not been set", nil)];
        return NO;
    }
    
    if (_schoolLocation == nil) {
        [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
             withDetail:NSLocalizedString(@"School location has not been set", nil)];
        return NO;
    }
    
    return YES;
}

- (void) addNewSchoolWithImageKeys {
    /*
     SRXDataClassInfoBuilder* classInfoBuilder = [SRXDataClassInfo builder];
     [classInfoBuilder setSummary:self.schoolNameTextField.text];
     [classInfoBuilder setLocationBuilder:
     [[[SRXDataLocation builder] setLatitude:_locationCoordinate2D.latitude] setLongtitude:_locationCoordinate2D.longitude]];*/
    
    SRXDataSchoolInfoBuilder* schoolInfoBuilder = [SRXDataSchoolInfo builder];
    [schoolInfoBuilder setName:self.schoolNameTextField.text];
    
    // Add new images.
    [self.imageDictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ((NSString*) key != plusSignFileName) {
            // Update the image to server as file.
            SRXImage* image = (SRXImage*) obj;
            NSAssert(image.uploaded, @"Exception: image is expected to be uploaded already.");
            
            // Ideally the view controller shouldn't know which server the backend is using.
            SRXDataImageRef* imageRef = [[[[SRXDataImageRef builder] setServerType:SRXDataImageServerTypeEnumImageServerTypeParse] setImageKey:image.serverKey] build];
            [schoolInfoBuilder addImageRef:imageRef];
        }
    }];
    
    [schoolInfoBuilder setSummary:self.schoolDescription];
    [schoolInfoBuilder setLocation:self.schoolLocation];
    // TODO: add more info about the class
    
    SRXProtoCreateSchoolRequestBuilder* createSchoolRequestBuilder = [SRXProtoCreateSchoolRequest builder];
    [createSchoolRequestBuilder setSchoolInfoBuilder:schoolInfoBuilder];
    
    SRXProtoCreateSchoolRequest* createSchoolRequest = [createSchoolRequestBuilder build];
    
    NSLog(@"Create class request: %@", createSchoolRequest);
    // TODO: add more info about the class.
    
    SRXProtoCreateSchoolResponseBuilder* createSchoolResponseBuilder = [SRXProtoCreateSchoolResponse builder];
    [[SRXApiFactory getActualApi] createSchool:createSchoolRequest withResponse:&createSchoolResponseBuilder
                                    completion:^(BOOL success, NSString* errorMsg) {
                                        if (success) {
                                             SRXDataSchoolInfo* schoolInfo = [createSchoolRequest schoolInfo];
                                             SRXProtoCreateSchoolResponse* createSchoolResponse = [createSchoolResponseBuilder build];
                                            SRXDataSchool* school = [[[[SRXDataSchool builder] setId:[createSchoolResponse schoolId]] setInfo:schoolInfo] build];
                                            
                                            [self.navigationController popViewControllerAnimated:YES];
                                             if([self.delegate respondsToSelector:@selector(schoolCreated:)]) {
                                                 [self.delegate schoolCreated:school];
                                             }
                                        } else {
                                            [self showAlert:NSLocalizedString(@"Error creating a new class", nil)
                                                 withDetail:NSLocalizedString(@"Failed to updte class info", nil)];
                                        }
                                    }];
}

- (IBAction)addNewClass:(id)sender {
    if (![self qualifedForAddNewSchool]) {
        return;
    }
    
    [self addNewSchoolWithImageKeys];
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

- (void) schoolLocationPicked:(CLLocationCoordinate2D) locationCoordinate {
    SRXDataLocationBuilder* builder = [SRXDataLocation builder];
    [builder setLatitude:locationCoordinate.latitude];
    [builder setLongtitude:locationCoordinate.longitude];
    
    _schoolLocation = [builder build];
    [self.infoTableView reloadData];
}

- (void) descriptionEntered:(NSString*) description {
    _schoolDescription = description;
    [self.infoTableView reloadData];
}

@end
