//
//  SRXProtocols.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/23/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#ifndef DropPinOnMapView_SRXProtocols_h
#define DropPinOnMapView_SRXProtocols_h

#import "SRXApi.pb.h"

@protocol SRXProtocols

// TODO: replace NSString* to NSError*
typedef void(^ApiCompletion)(BOOL, NSString*);

- (void) createClass:(SRXProtoCreateClassRequest*) request
        withResponse:(SRXProtoCreateClassResponse**) response
        completion:(ApiCompletion) compblock;

- (void) readClass: (SRXProtoReadClassRequest*) request
      withResponse: (SRXProtoReadClassResponseBuilder**) responseBuilder
        completion:(ApiCompletion) compblock;

- (void) searchClass: (SRXProtoSearchClassRequest*) request
      withResponse: (SRXProtoSearchClassResponseBuilder**) responseBuilder
        completion:(ApiCompletion) compblock;


@end

#endif
