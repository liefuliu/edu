//
//  SRXStudentClassViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 10/3/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRXDataClass.pb.h"

@interface SRXStudentClassViewController : UITableViewController

@property SRXDataClassInfo* classInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAtTop;

-(instancetype) initWithClassInfo: (SRXDataClassInfo*) classInfo;

// Shall we pass in Class ID or entire class info?
//

@end
