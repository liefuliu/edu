//
//  SRXTeacherMeViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/22/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXTeacherMeViewController.h"

@interface SRXTeacherMeViewController ()

@end

@implementation SRXTeacherMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)buttonToStudyClicked:(id)sender {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"BeStudent"];
    [self presentViewController: mainViewController animated:YES completion: NULL];

}

- (IBAction)buttonToStudyNewClicked:(id)sender {
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
