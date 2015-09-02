//
//  SRXLogInDetailViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/28/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "ViewController.h"
#import "SRXUserAccountSuperViewController.h"

@interface SRXLogInDetailViewController : SRXUserAccountSuperViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonLogIn;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UILabel *labelErrorMsg;
@end
