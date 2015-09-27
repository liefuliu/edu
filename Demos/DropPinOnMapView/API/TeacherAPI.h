//
//  TeacherAPI.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/22/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "API.pb.h"

@class SRXAPIMutateDataRequest;
@class SRXAPIMutateDataResponse;

@interface TeacherAPI : NSObject

typedef void(^teacherAPICompletion)(BOOL);

+(void) mutateData:(SRXAPIMutateDataRequest*) mutateDataRequest
      withResponse:(SRXAPIMutateDataResponse**) mutateDataResponse
        completion:(teacherAPICompletion) compblock;

/*
 Following action need to be added:
 
 MutateData
    - Add a class
    - Mutate a class
    - Register on a class
    - Confirm registration on a class
 
 ReadData
    - Load the class

 QueryData
    - Get all the classes near a point

 */

                   
@end
