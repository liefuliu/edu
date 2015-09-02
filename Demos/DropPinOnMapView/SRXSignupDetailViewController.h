//
//  SRXSignInViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/26/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXUserAccountSuperViewController.h"

@interface SRXSignUpDetailViewController : SRXUserAccountSuperViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonSignUp;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPersonName;
@property (weak, nonatomic) IBOutlet UILabel *labelErrorMsg;

@end
