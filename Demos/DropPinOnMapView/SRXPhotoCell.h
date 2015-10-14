//
//  SRXPhotoCell.h
//  DropPinOnMapView
//
//  Defines a collection view cell with a thumbnail image.
//
//  Created by Liefu Liu on 9/10/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface SRXPhotoCell : UICollectionViewCell


@property (nonatomic, strong) UIImage* image;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end
