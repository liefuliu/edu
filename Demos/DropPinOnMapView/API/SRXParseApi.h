//
//  SRXParseApi.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/24/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//
//  TODO(liefuliu): add more comments.

#import <Foundation/Foundation.h>
#import "SRXProtocols.h"

@interface SRXParseApi : NSObject<SRXProtocols>

+ (id) sharedObject;

- (id) init;

- (void) createClass:(SRXProtoCreateClassRequest*) request
        withResponse:(SRXProtoCreateClassResponse**) response
          completion:(ApiCompletion) compblock;

- (void) readClass: (SRXProtoReadClassRequest*) request
      withResponse: (SRXProtoReadClassResponseBuilder**) response
        completion:(ApiCompletion) compblock;

- (void) searchClass: (SRXProtoSearchClassRequest*) request
      withResponse: (SRXProtoSearchClassResponseBuilder**) responseBuilder
        completion:(ApiCompletion) compblock;


- (void) addImages: (SRXProtoAddImagesRequest*) request
      withResponse: (SRXProtoAddImagesResponseBuilder**) responseBuilder
        completion: (ApiCompletion) compblock;

- (void) getImages: (SRXProtoGetImagesRequest*) request
      withResponse: (SRXProtoGetImagesResponseBuilder**) responseBuilder
        completion: (ApiCompletion) compblock;

- (void) getOwnedSchool: (SRXProtoGetOwnedSchoolRequest*) request
           withResponse: (SRXProtoGetOwnedSchoolResponseBuilder**) responseBuilder
             completion: (ApiCompletion) compblock;

- (void) createSchool: (SRXProtoCreateSchoolRequest*) request
         withResponse: (SRXProtoCreateSchoolResponseBuilder**) responseBuilder
           completion: (ApiCompletion) compblock;


@property (nonatomic, retain) NSString *someProperty;

@end
