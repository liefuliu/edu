//
//  SRXImageViewerController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/11/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRXImageViewController : UIViewController <UIScrollViewDelegate>

// TODO: support multiple UIImages in the view controller.

- (instancetype) initWithImageArray: (NSArray*) imageArray;

- (instancetype) initWithImage: (UIImage*) image;

@end
