//
//  SRXTeacherOpenClassViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/7/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCimagePickerHeader.h"

@interface SRXTeacherOpenClassViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *classInfoTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *classDescriptionTextField;

@end
