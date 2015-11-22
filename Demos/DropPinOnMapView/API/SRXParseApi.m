//
//  SRXParseApi.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/24/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXParseApi.h"

#import <Parse/Parse.h>


@implementation SRXParseApi

const NSString* __nonnull kClassTable = @"Class";
const NSString* __nonnull kClassTableClassInfoKey = @"ClassInfo";
const NSString* __nonnull kClassTableUserKey = @"Owner";
const NSString* __nonnull kClassTableLocationKey = @"Location";


const NSString* __nonnull kImageTable = @"Photo";
const NSString* __nonnull kImageTableKeyColumn = @"PhotoKey";
const NSString* __nonnull kImageTableDataColumn = @"PhotoRef";


const NSString* __nonnull kSchoolTableSchoolInfoKey = @"SchoolInfo";
const NSString* __nonnull kSchoolTableLocation = @"Location";
const NSString* __nonnull kSchoolTable = @"School";
const NSString* __nonnull kSchoolTableUserKey = @"Owner";
const NSString* __nonnull kSchoolTableLocationKey = @"Location";

@synthesize someProperty;

+ (id)sharedObject {
    static SRXParseApi *sharedParseApi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParseApi = [[self alloc] init];
    });
    return sharedParseApi;
}

- (id)init {
    if (self = [super init]) {
        someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}


ApiCompletion _completionHandler;

- (void) createClass:(SRXProtoCreateClassRequest*) request
        withResponse:(SRXProtoCreateClassResponse**) response
          completion:(ApiCompletion) compblock {
    _completionHandler = [compblock copy];
    
    PFUser *user = [PFUser currentUser];
    NSLog(@"current user: %@", user);
    if (user == nil) {
        _completionHandler(false, @"fail");
        return;
    }
    if (request.classInfo == nil) {
        _completionHandler(false, @"request cannot be nil");
        return;
    }
    NSLog(@"request.classInfo.summary.length = %d, text = %@", request.classInfo.summary.length, request.classInfo.summary);
    if (request.classInfo.summary.length == 0) {
        _completionHandler(false, @"Summary cannot be empty");
        return;
    }
    
    // If the data is valid, we will need to
    // Store the class info in Class table, and retrieve an object Id.
    
    // Save the PFUser Id and location.
    PFObject *gameScore = [PFObject objectWithClassName:kClassTable];
    gameScore[kClassTableClassInfoKey] = [request.classInfo data];
    
    // TODO: We might need support multi-modal user name.
    gameScore[kClassTableUserKey] = [user username];
    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:request.classInfo.location.latitude
                                               longitude:request.classInfo.location.longtitude];
    gameScore[kClassTableLocationKey] = point;
    
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            _completionHandler(true, @"success");
            
            // Parse doesn't support transaction and thus we will not implement roll back here.
            
        } else {
            // There was a problem, check error.description
            _completionHandler(true, @"Failed to upload data to Parse");
        }
    }];
    
    // TODO: Append the object Id to the user info (as an index).
}

- (void) readClass: (SRXProtoReadClassRequest*) request
      withResponse: (SRXProtoReadClassResponseBuilder**) responseBuilder
        completion:(ApiCompletion) compblock {
    _completionHandler = [compblock copy];
    
    PFUser *user = [PFUser currentUser];
    NSLog(@"current user: %@", user);
    if (user == nil) {
        _completionHandler(false, @"fail");
        return;
    }
    if ([request roleInClass] == SRXDataRoleInClassTypeEnumSRXDataRoleInClassTypeOwner) {
        PFQuery *query = [PFQuery queryWithClassName:kClassTable];
        [query whereKey:kClassTableUserKey equalTo:[user username]];
        
        
        /*__block __weak SRXParseApi *wself = self;
         
         [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         if (!error) {
         // The find succeeded.
         NSLog(@"Successfully retrieved %d scores.", objects.count);
         SRXProtoReadClassResponseBuilder* responseBuilder = [SRXProtoReadClassResponse builder];
         
         // Do something with the found objects.
         for (PFObject *object in objects) {
         SRXDataClassInfo* classInfo;
         classInfo = [SRXDataClassInfo parseFromData: object[kClassTableClassInfoKey]];
         NSLog(@"%@", classInfo);
         
         [responseBuilder addClasses:classInfo];
         }
         *response = [responseBuilder build];
         } else {
         // Log details of the failure.
         NSLog(@"Error: %@ %@", error, [error userInfo]);
         _completionHandler(false, @"Failed to read class info.");
         return;
         }
         }];
         */
        
        // TODO: move the findObjects on background thread.
        NSArray* objects = [query findObjects];
        NSLog(@"Successfully retrieved %d classes.", objects.count);
        
        for (PFObject *object in objects) {
            SRXDataClassInfo* classInfo;
            classInfo = [SRXDataClassInfo parseFromData: object[kClassTableClassInfoKey]];
            [*responseBuilder addClassCollection:classInfo];
        }
    } else {
        _completionHandler(false, @"Unsupported role type");
        return;
    }
    
    _completionHandler(true, nil);
}



- (void) searchClass: (SRXProtoSearchClassRequest*) request
        withResponse: (SRXProtoSearchClassResponseBuilder**) responseBuilder
          completion:(ApiCompletion) compblock {
    // User's location
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:request.latitude
                                               longitude:request.longtitude];
    // Create a query for places
    PFQuery *query = [PFQuery queryWithClassName:kClassTable];
    // Interested in locations near user.
    [query whereKey:kClassTableLocationKey nearGeoPoint:point];
    // Limit what could be a lot of points.
    // TODO(liefuliu): specify the query.limit in the request.
    query.limit = 10;
    // Final list of objects
    NSArray* placesObjects = [query findObjects];
    
    // Do something with the found objects.
    for (PFObject *object in placesObjects) {
        SRXDataClassInfo* classInfo;
        classInfo = [SRXDataClassInfo parseFromData: object[kClassTableClassInfoKey]];
        NSLog(@"%@", classInfo);
        
        [*responseBuilder addClassCollection:classInfo];
    }
    
    _completionHandler = [compblock copy];
    _completionHandler(true, nil);
}


- (void) getCurrentUser: (SRXProtoGetCurrentUserRequest*) request
          withResponse : (SRXProtoGetCurrentUserResponseBuilder**) responseBuilder
             completion: (ApiCompletion) compblock {
    if ([PFUser currentUser]) {
        [*responseBuilder setSignedIn:YES];
    } else {
        [*responseBuilder setSignedIn:NO];
    }
    
    if (compblock != nil) {
    _completionHandler = [compblock copy];
    _completionHandler(true, nil);
    }
}

/* This parallel implementation doesn't work
 - (void) addImages: (SRXProtoAddImagesRequest*) request
 withResponse: (SRXProtoAddImagesResponseBuilder**) responseBuilder
 completion: (ApiCompletion) compblock {
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
 __block bool is_everyone_succeeded = true;
 __block NSMutableArray *imageKeys = [[NSMutableArray alloc] init];
 dispatch_group_t group = dispatch_group_create();
 for (SRXProtoImage* image in [request image]) {
 PFFile *imageFile = [PFFile fileWithName:@"image.png" data:[image data]];
 
 PFObject *userPhoto = [PFObject objectWithClassName:kImageTable];
 NSString *uuidString = [[NSUUID UUID] UUIDString];
 
 userPhoto[kImageTableKeyColumn] = uuidString;
 userPhoto[kImageTableDataColumn] = imageFile;
 //[userPhoto saveInBackground];
 dispatch_group_enter(group);
 [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
 if (!succeeded) {
 // TODO: delete all the photos which has been uploaded in this request.
 is_everyone_succeeded = false;
 }
 
 [imageKeys addObject:uuidString];
 dispatch_group_leave(group);
 }];
 }
 
 dispatch_async(dispatch_get_main_queue(), ^{ // 6
 if (is_everyone_succeeded) {
 NSLog(@"Successfully add photo");
 for (NSString* imageKey in imageKeys) {
 [*responseBuilder addImageKey:imageKey];
 }
 
 _completionHandler(true, @"success");
 } else {
 NSLog(@"Failed to add photo");
 _completionHandler(false, @"failed to add photo");
 }
 });
 });
 }*/

- (void) addImages: (SRXProtoAddImagesRequest*) request
      withResponse: (SRXProtoAddImagesResponseBuilder**) responseBuilder
        completion: (ApiCompletion) compblock {
    _completionHandler = [compblock copy];
    NSMutableArray* imageKeys = [[NSMutableArray alloc] init];
    
    for (SRXProtoImage* image in [request image]) {
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:[image data]];
        
        PFObject *userPhoto = [PFObject objectWithClassName:kImageTable];
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        
        userPhoto[kImageTableKeyColumn] = uuidString;
        userPhoto[kImageTableDataColumn] = imageFile;
        
        // TODO(liefuliu): change the save function into background.
        bool successful = [userPhoto save];
        
        if (!successful) {
            NSLog(@"Failed to add photo");
            _completionHandler(false, @"failed to add photo");
        } else {
            NSLog(@"Saved image key: %@", uuidString);
            [imageKeys addObject:uuidString];
        }
    }
    
    
    NSLog(@"Successfully add photo");
    for (NSString* imageKey in imageKeys) {
        [*responseBuilder addImageKey:imageKey];
    }
    
    _completionHandler(true, @"success");
}



- (void) getImages: (SRXProtoGetImagesRequest*) request
      withResponse: (SRXProtoGetImagesResponseBuilder**) responseBuilder
        completion: (ApiCompletion) compblock {
    _completionHandler = [compblock copy];
    
    if ([[request imageKey] count] == 0) {
        _completionHandler(true, @"");
        return;
    }
    
    NSMutableString* imageKeyGroupWithCurlyBrace = [NSMutableString stringWithFormat:@"{'%@'", [request imageKey][0]];
    for (int i = 1; i < [[request imageKey] count]; i++) {
        [imageKeyGroupWithCurlyBrace appendFormat:@",'%@'",[request imageKey][i]];
    }
    [imageKeyGroupWithCurlyBrace appendString:@"}"];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"%@ IN %@", kImageTableKeyColumn, imageKeyGroupWithCurlyBrace];
    
    PFQuery *query = [[PFQuery queryWithClassName:kImageTable] whereKey:kImageTableKeyColumn containedIn:[request imageKey]];
    
    __block SRXProtoGetImagesResponseBuilder* reponseBuilderRef = *responseBuilder;
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *imageKeyObjects, NSError *error){
        if (error) {
            _completionHandler(false, @"failed to fetch image reference");
        } else {
            NSLog(@"Successfully fetched image reference. ");
            for (PFObject *imageKeyObject in imageKeyObjects) {
                PFFile *imageFile = imageKeyObject[kImageTableDataColumn];
                /*[imageFile getData:^(NSData *imageData, NSError *error) {
                 if (!error) {
                 [*responseBuilder addImageData:imageData];
                 } else {
                 _completionHandler(false, @"failed to fetch image");
                 }
                 }];*/
                
                NSData* imageData = [imageFile getData];
                if (imageData == nil) {
                    _completionHandler(false, @"failed to fetch image");
                    return;
                } else {
                    SRXDataImage* srxDataImage = [[[SRXDataImage builder] setData:imageData] build];
                    [reponseBuilderRef addImageData:srxDataImage];
                }
            }
            _completionHandler(true, @"");
        }
    }];
}

- (void) getOwnedSchool: (SRXProtoGetOwnedSchoolRequest*) request
           withResponse: (SRXProtoGetOwnedSchoolResponseBuilder**) responseBuilder
             completion: (ApiCompletion) compblock {
    
    
    _completionHandler = [compblock copy];
    
    PFUser *user = [PFUser currentUser];
    NSLog(@"current user: %@", user);
    if (user == nil) {
        _completionHandler(false, @"Fail: requesting user is different from the school owner.");
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:kSchoolTable];
    [query whereKey:kSchoolTableUserKey equalTo:[user username]];
    
    __block SRXProtoGetOwnedSchoolResponseBuilder* reponseBuilderRef = *responseBuilder;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d schools.", objects.count);
            
            for (PFObject *object in objects) {
                SRXDataSchoolInfo* schoolInfo = [SRXDataSchoolInfo parseFromData: object[kSchoolTableSchoolInfoKey]];
                NSString* schoolId = (NSString*) object[@"objectId"];
                
                SRXDataSchool* school = [[[[SRXDataSchool builder] setId:schoolId] setInfo:schoolInfo] build];
                                                        
                                                        
                [reponseBuilderRef addSchool:school];
            }
            _completionHandler(true, nil);
        } else {
            // Log details of the failure
            _completionHandler(false, [error userInfo]);
        }
    }];
}

- (void) createSchool: (SRXProtoCreateSchoolRequest*) request
         withResponse: (SRXProtoCreateSchoolResponseBuilder**) responseBuilder
           completion: (ApiCompletion) compblock {
    _completionHandler = [compblock copy];
    
    PFUser *user = [PFUser currentUser];
    NSLog(@"current user: %@", user);
    if (user == nil) {
        _completionHandler(false, @"Fail: requesting user is different from the school owner.");
        return;
    }
    if (request.schoolInfo == nil) {
        _completionHandler(false, @"school_info field cannot be nil");
        return;
    }
    
    if (request.schoolInfo.description.length == 0) {
        _completionHandler(false, @"School description cannot be empty");
        return;
    }
    if (request.schoolInfo.name.length == 0) {
        _completionHandler(false, @"School name cannot be empty");
        return;
    }
    
    // If the data is valid, we will need to
    // Store the school info in school table, and retrieve an object Id.
    // Save the PFUser Id and location.
    PFObject *gameScore = [PFObject objectWithClassName:kSchoolTable];
    gameScore[kSchoolTableSchoolInfoKey] = [request.schoolInfo data];
    
    // TODO: We might need support multi-modal user name.
    gameScore[kClassTableUserKey] = [user username];
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:request.schoolInfo.location.latitude
                                               longitude:request.schoolInfo.location.longtitude];
    gameScore[kClassTableLocationKey] = point;
    
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            _completionHandler(true, @"success");
            // Parse doesn't support transaction and thus we will not implement roll back here.
        } else {
            // There was a problem, check error.description
            _completionHandler(true, @"Failed to upload data to Parse");
        }
    }];
    
  
}

@end
