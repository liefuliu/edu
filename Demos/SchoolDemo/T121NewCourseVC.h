//
//  T121NewCourseVCTableViewController.h
//  SchoolDemo
//
//  Created by Liefu Liu on 11/1/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRXSingleSelectionTableViewController.h"
#import "SDCourse.h"

@protocol T121NewCourseVCDelegate
- (void) courseCreated: (SDCourse*) course;
@end

@interface T121NewCourseVC : UITableViewController <SRXSingleSelectionTableViewControllerDelegate>

@property (nonatomic, weak) id delegate;

@end
