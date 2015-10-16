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
@property (nonatomic, strong) NSMutableArray* imageArray;
@property (nonatomic) int currentDisplayedImageIndex;
@end


#pragma mark -

@implementation SRXImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    
    self.imageView.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [swipeleft setDelegate:self];

    [self.imageView addGestureRecognizer:swipeleft];
    
    
    UISwipeGestureRecognizer * swiperight =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [swiperight setDelegate:self];
    
    [self.imageView addGestureRecognizer:swiperight];
    
    self.currentDisplayedImageIndex = 0;
    
    if ([self.imageArray count] > 0) {
        self.imageView.image = self.imageArray[0];
    }
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    self.currentDisplayedImageIndex = (self.currentDisplayedImageIndex + [self.imageArray count] - 1) % [self.imageArray count];
    self.imageView.image = self.imageArray[self.currentDisplayedImageIndex];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    self.currentDisplayedImageIndex = (self.currentDisplayedImageIndex + 1) % [self.imageArray count];
    self.imageView.image = self.imageArray[self.currentDisplayedImageIndex];
}

- (instancetype) initWithImageArray: (NSArray*) imageArray {
    self = [super init];
    if (self) {
        _imageArray = imageArray;
    }
    return self;
}

- (instancetype) initWithImage: (UIImage*) image {
    self = [super init];
    if (self) {
        _imageArray = [[NSMutableArray alloc] init];
        [_imageArray addObject:image];
    }
    return self;

}

@end
