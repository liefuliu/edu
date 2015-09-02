//
//  SRXLogInViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/28/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXLogInViewController.h"
#import "SRXLogInDetailViewController.h"
#import "SRXColor.h"

@interface SRXLogInViewController ()

@end

@implementation SRXLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userNameField.delegate = self;
    
    // Disable the wechat login for now.
    self.buttonWxLogIn.backgroundColor = [SRXColor colorForWeixinLogInDisabled];
    self.buttonWxLogIn.enabled = NO;
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

- (IBAction)userNameTouchedDown:(id)sender {
    SRXLogInDetailViewController* logInDetailViewController = [[SRXLogInDetailViewController alloc] init];
    [self.navigationController pushViewController:logInDetailViewController animated:YES];
}

- (IBAction)userNameFieldEditBegan:(id)sender {
}





@end
