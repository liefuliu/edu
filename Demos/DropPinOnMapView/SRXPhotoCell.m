//
//  SRXPhotoCell.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/10/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXPhotoCell.h"

@interface SRXPhotoCell()

// 1
@property(nonatomic, weak) IBOutlet UIImageView *photoImageView;
@end

@implementation SRXPhotoCell

- (void) setImage: (UIImage*) image {
    self.photoImageView.image = image;
}

@end