//
//  SRXTeacherClassViewControllerTableViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/6/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRXTeacherOpenClassViewController.h"

@interface SRXTeacherClassTableViewController : UITableViewController <SRXTeacherOpenClassViewControllerDelegate>

- (void) newClassCreated;

@end
