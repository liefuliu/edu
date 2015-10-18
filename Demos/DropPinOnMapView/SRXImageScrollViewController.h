//
//  SRXImageScrollViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 10/17/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRXImageScrollViewController : UIViewController


// TODO: support multiple UIImages in the view controller.

- (instancetype) initWithImageArray: (NSArray*) imageArray;

- (instancetype) initWithImage: (UIImage*) image;

@end
