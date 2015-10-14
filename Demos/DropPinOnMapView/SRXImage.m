//
//  SRXImage.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 10/11/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXImage.h"

@implementation SRXImage


- (instancetype) initImage:(UIImage*) image
              withFilename:(NSString*) fileName {
    self = [super init];
    if (self) {
        _image = image;
        _fileName = fileName;
    }
    return self;
}


- (void) MarkAsUploadedWithServerKey:(NSString*) serverKey {
    _uploaded = YES;
    _serverKey = serverKey;
}

@end
