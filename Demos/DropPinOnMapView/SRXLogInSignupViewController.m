//
//  SRXLogInViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/26/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXLogInSignUpViewController.h"

#import "SRXSignUpDetailViewController.h"
#import "SRXLogInViewController.h"
#import "SRXSignUpViewController.h"
#import "SRXColor.h"

@interface SRXLogInSignUpViewController ()

@end

@implementation SRXLogInSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializeColor];
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
    [self.buttonSignUp setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
    
    self.buttonLogIn.backgroundColor = [SRXColor colorForLogIn];
    [self.buttonLogIn setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
}

- (IBAction)buttonSignInClicked:(id)sender {
    SRXSignUpViewController* signUpViewController = [[SRXSignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

- (IBAction)buttonLogInClicked:(id)sender {
    SRXLogInViewController* logInViewController = [[SRXLogInViewController alloc] init];
    [self.navigationController pushViewController:logInViewController animated:YES];
}

@end
