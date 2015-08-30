//
//  SRXSignUpViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/28/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXSignUpViewController.h"
#import "SRXSignUpDetailViewController.h"
#import "SRXColor.h"
@interface SRXSignUpViewController ()

@end

@implementation SRXSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.buttonWeixinLogIn.backgroundColor = [SRXColor colorForWeixinLogIn];
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


- (IBAction)textFieldUserNameTouchedDown:(id)sender {
    SRXSignUpDetailViewController* signUpDetailViewController = [[SRXSignUpDetailViewController alloc] init];
    [self.navigationController pushViewController:signUpDetailViewController animated:YES];
}

@end
