//
//  SRXTeacherOpenClassViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/7/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCimagePickerHeader.h"
#import "SRXDataClass.pb.h"

@protocol SRXTeacherOpenClassViewControllerDelegate <NSObject>
- (void) newClassCreated;
@end


@interface SRXTeacherOpenClassViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate,ELCImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *classInfoTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *classDescriptionTextField;

// Class info from the create class panel.
@property (strong, nonatomic) SRXDataClassInfo* classInfo;

@property (nonatomic, weak) id delegate;

@end
