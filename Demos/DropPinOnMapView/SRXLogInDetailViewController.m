//
//  SRXLogInDetailViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/28/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXLogInDetailViewController.h"
#import "SRXColor.h"
#import "SRXUserInputVerifier.h"
#import <Parse/Parse.h>

@interface SRXLogInDetailViewController ()

@property bool isAbleToLogin;

@end

@implementation SRXLogInDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textFieldPassword.secureTextEntry = YES;
    self.buttonLogIn.backgroundColor = [SRXColor colorForLogIn];
    
    self.labelErrorMsg.textColor = [UIColor redColor];
    self.labelErrorMsg.hidden = YES;
    
    self.isAbleToLogin = false;
    [self enableLogInButton:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logInButtonTouched:(id)sender {
    NSString* userName = self.textFieldUserName.text;
    NSString* password = self.textFieldPassword.text;
    
    [PFUser logInWithUsernameInBackground:userName
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
         if (user) {
             NSLog(@"PFUser after logInButtonTouched: %@", [PFUser currentUser]);
             [self.navigationController dismissModalViewControllerAnimated:YES];
             [self.navigationController popToRootViewControllerAnimated:NO];
         } else {
             // The login failed. Check error to see why.
             self.labelErrorMsg.hidden = NO;
             self.labelErrorMsg.text = [error localizedDescription];
             [self.labelErrorMsg sizeToFit];
         }
     }];
}

- (IBAction)userNameEditingChanged:(id)sender {
    [self inputTextUpdated];
}

- (IBAction)passWordEditingChanged:(id)sender {
    [self inputTextUpdated];
}


- (void) inputTextUpdated {
    if (self.textFieldUserName.text.length > 0 &&
        self.textFieldPassword.text.length > 0) {
        [self enableLogInButton:YES];
    } else {
        [self enableLogInButton:NO];
    }
}

- (void) enableLogInButton: (BOOL) enabled {
    if (enabled) {
        self.buttonLogIn.enabled = YES;
        self.buttonLogIn.backgroundColor = [SRXColor colorForSignUp];
    } else {
        self.buttonLogIn.enabled = NO;
        self.buttonLogIn.backgroundColor = [SRXColor colorForSignUpLowlighted];
    }
}

/* TODO(liefuliu): Enable following code to validate the input text locally.
- (void) validateInputText {
    bool previousIsAbleToLogIn =  self.isAbleToLogin;
    bool isUserNameValid = [SRXUserInputVerifier mightBeValidEmail:self.textFieldUserName.text];
    bool isPasswordValid = [SRXUserInputVerifier mightBeValidPassword:self.textFieldPassword.text];
    
    self.isAbleToLogin =  isUserNameValid && isPasswordValid;
    if (self.isAbleToLogin) {
        NSLog(@"Username and password is valid");
    } else {
        NSLog(@"Username and password is NOT valid");
    }

        if (self.isAbleToLogin) {
            self.labelErrorMsg.hidden = YES;
        } else {
            if (self.textFieldUserName.text.length > 0 && !isUserNameValid) {
                self.labelErrorMsg.text = @"请输入完整的电子邮件地址";
                self.labelErrorMsg.hidden = NO;
            } else if (self.textFieldPassword.text.length > 0 && !isPasswordValid) {
                self.labelErrorMsg.text = @"密码至少6位";
                self.labelErrorMsg.hidden = NO;
            } else {
                self.labelErrorMsg.hidden = YES;
            }
        }
    
    if (previousIsAbleToLogIn != self.isAbleToLogin) {
        
        [self reloadButton];
    }
}

- (void) reloadButton {
    self.buttonLogIn.enabled = self.isAbleToLogin;
    if (self.isAbleToLogin) {
        self.buttonLogIn.backgroundColor = [SRXColor colorForLogIn];
    } else {
        self.buttonLogIn.backgroundColor = [SRXColor colorForLogInLowlighted];
    }
}
*/

@end
