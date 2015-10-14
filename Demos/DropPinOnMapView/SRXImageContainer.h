//
//  SRXImageContainer.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 10/11/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRXImage.h"

@interface SRXImageContainer : NSObject

// The array of SRXImage.
@property (nonatomic) NSArray* imagesArray;

// The map of key and
@property (nonatomic) NSDictionary* imagesDictionary;

@end
