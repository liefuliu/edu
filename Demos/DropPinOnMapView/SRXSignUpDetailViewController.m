//
//  SRXSignInViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/26/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXSignUpDetailViewController.h"
#import "SRXColor.h"
#import "SRXUserInfoKeys.h"
#import "SRXUserInputVerifier.h"
#import <Parse/Parse.h>

@interface SRXSignUpDetailViewController ()

@end

@implementation SRXSignUpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeColor];
    self.textFieldPassword.secureTextEntry = YES;
    
    // DO NOT SUBMIT self.isAbleToLogin = false;
    [self enableSignUpButton:NO];
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

- (void) initializeColor {
    self.buttonSignUp.backgroundColor = [SRXColor colorForSignUp];
    self.labelErrorMsg.hidden = YES;
    //self.labelErrorMsg.lineBreakMode = NSLineBreakByWordWrapping;
    //self.labelErrorMsg.numberOfLines = 0;
    self.labelErrorMsg.textColor = [UIColor redColor];
}
- (IBAction)textFieldEmailEditingChanged:(id)sender {
    [self inputTextUpdated];
}
- (IBAction)textFieldPasswordEditingChanged:(id)sender {
    [self inputTextUpdated];
}

- (IBAction)textFieldPersonNameEditingChanged:(id)sender {
    [self inputTextUpdated];
}


- (IBAction)signupButtonClicked:(id)sender {
    [self.view endEditing:YES];
    
    PFUser *user = [PFUser user];
    user.username = self.textFieldEmail.text;
    user.password = self.textFieldPassword.text;
    user.email = self.textFieldEmail.text;
    
    user[UserInfoKey_PersonName] = self.textFieldPersonName.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            NSLog(@"PFUser after logInButtonTouched: %@", [PFUser currentUser]);
            [self.navigationController dismissModalViewControllerAnimated:YES];
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
            self.labelErrorMsg.hidden = NO;
            self.labelErrorMsg.text = [error localizedDescription];
            [self.labelErrorMsg sizeToFit];
        }
    }];
}


- (void) inputTextUpdated {
    if (self.textFieldEmail.text.length > 0 &&
        self.textFieldPassword.text.length > 0 &&
        self.textFieldPersonName.text.length > 0) {
        NSLog(@"enableSignupButton true");
        [self enableSignUpButton:YES];
    } else {
        NSLog(@"enableSignupButton false");
        [self enableSignUpButton:NO];
    }
}

- (void) enableSignUpButton: (BOOL) enabled {
    if (enabled) {
        self.buttonSignUp.enabled = YES;
        self.buttonSignUp.backgroundColor = [SRXColor colorForSignUp];
    } else {
        self.buttonSignUp.enabled = NO;
        self.buttonSignUp.backgroundColor = [SRXColor colorForSignUpLowlighted];
    }
}

/* TODO(liefuliu): Enable following code to validate the input text locally.
- (BOOL) validateInputEmail:(NSString*) email
                   withPassword:(NSString*) password
                 withpersonName:(NSString*) personName{
    return true;
}
    bool previousIsAbleToLogIn =  self.isAbleToLogin;
    bool isUserNameValid = [SRXUserInputVerifier mightBeValidEmail:self.textFieldEmail.text];
    bool isPasswordValid = [SRXUserInputVerifier mightBeValidPassword:self.textFieldPassword.text];
    bool isPersonNameValid = [SRXUserInputVerifier mightBeValidPersonName:self.textFieldPersonName.text];
    
    self.isAbleToLogin =  isUserNameValid && isPasswordValid && isPersonNameValid;
    if (self.isAbleToLogin) {
        NSLog(@"Username and password is valid");
    } else {
        NSLog(@"Username and password is NOT valid");
    }
    
    if (self.isAbleToLogin) {
        self.labelErrorMsg.hidden = YES;
    } else {
        if (self.textFieldEmail.text.length > 0 && !isUserNameValid) {
            self.labelErrorMsg.text = @"请输入完整的电子邮件地址";
            self.labelErrorMsg.hidden = NO;
        } else if (self.textFieldPassword.text.length > 0 && !isPasswordValid) {
            self.labelErrorMsg.text = @"密码至少6位";
            self.labelErrorMsg.hidden = NO;
        } else if (self.textFieldPersonName.text == 0) {
            self.labelErrorMsg.text = @"请输入姓名";
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
    self.buttonSignUp.enabled = self.isAbleToLogin;
    if (self.isAbleToLogin) {
        self.buttonSignUp.backgroundColor = [SRXColor colorForSignUp];
    } else {
        self.buttonSignUp.backgroundColor = [SRXColor colorForSignUpLowlighted];
    }
}*/

@end
