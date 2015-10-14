//
//  SRXImage.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 10/11/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SRXImage : NSObject

@property (readonly, nonatomic) BOOL uploaded;
@property (readonly, nonatomic) NSString* fileName;
@property (readonly, nonatomic) UIImage* image;
@property (readonly, nonatomic) NSString* serverKey;

- (instancetype) initImage:(UIImage*) image
              withFilename:(NSString*) fileName;

- (void) MarkAsUploadedWithServerKey:(NSString*) serverKey;

/*
- (void) uploadImagesWithProgress:^(float completion_percent) {
    
}
*/

@end
