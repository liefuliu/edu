//
//  T0CreateSchoolVC.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 11/11/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRXDataSchool.pb.h"


@protocol T0CreateSchoolVCDelegate <NSObject>
- (void) schoolCreated: (SRXDataSchool*) school;
@end


@interface T0CreateSchoolVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *schoolNameTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@property (nonatomic, weak) id delegate;

@end