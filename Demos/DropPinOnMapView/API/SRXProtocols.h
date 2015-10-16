//
//  SRXProtocols.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/23/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//
//  This protocol defines all the backend API used by this App. App communicates to the remote
//  server by calling APIs declared in this file. 

#ifndef DropPinOnMapView_SRXProtocols_h
#define DropPinOnMapView_SRXProtocols_h

#import "SRXApi.pb.h"

@protocol SRXProtocols

// TODO(liefuliu): replace NSString* to NSError*
typedef void(^ApiCompletion)(BOOL, NSString*);

// Submits a request to server to create a class. Execution happens in the background thread.
//  'compblock' will be evoked once the server responses.
- (void) createClass:(SRXProtoCreateClassRequest*) request
        withResponse:(SRXProtoCreateClassResponse**) response
        completion:(ApiCompletion) compblock;

// Submits a request to server to get the detail info a a class. Execution happens in the background
// thread. 'compblock' will be evoked once the server responses.
- (void) readClass: (SRXProtoReadClassRequest*) request
      withResponse: (SRXProtoReadClassResponseBuilder**) responseBuilder
        completion:(ApiCompletion) compblock;

// Submits a request to server to search a class, given a map range. Execution happens in the
// background thread. 'compblock' will be evoked once the server responses.
- (void) searchClass: (SRXProtoSearchClassRequest*) request
      withResponse: (SRXProtoSearchClassResponseBuilder**) responseBuilder
        completion:(ApiCompletion) compblock;

// Submits a request to server to upload one or multiple images. Execution happens in the background
// thread. 'compblock' will be evoked once the server responses.
- (void) addImages: (SRXProtoAddImagesRequest*) request
      withResponse: (SRXProtoAddImagesResponseBuilder**) responseBuilder
        completion: (ApiCompletion) compblock;

- (void) getImages: (SRXProtoGetImagesRequest*) request
      withResponse: (SRXProtoGetImagesResponseBuilder**) responseBuilder
        completion: (ApiCompletion) compblock;

@end

#endif
