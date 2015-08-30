//
//  SRXLogInViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/28/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXUserAccountSuperViewController.h"

@interface SRXLogInViewController : SRXUserAccountSuperViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UIButton *buttonWxLogIn;

@end
