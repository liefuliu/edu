//
//  SRXImageViewerController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/11/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXImageViewController.h"

@interface SRXImageViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end


#pragma mark -

@implementation SRXImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.image;
}

@end
