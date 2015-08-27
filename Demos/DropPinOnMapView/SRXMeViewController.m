//
//  SRXMeViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/22/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXMeViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseUI/PFLogInViewController.h>

@interface SRXMeViewController () <PFLogInViewControllerDelegate>

@end

@implementation SRXMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [PFUser logOut];
    
}

- (void) viewDidAppear:(BOOL)animated {
    /* TODO: enable following code*/
    PFUser *user = [PFUser currentUser];
    NSLog(@"PFUser: %@", user);
    if(user == nil) {
        PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
        logInController.logInView.signUpButton.titleLabel.text = @"注册";
        logInController.logInView.signUpButton.backgroundColor = [UIColor blackColor];
        logInController.logInView.logInButton.backgroundColor = [UIColor redColor];
        logInController.delegate = self;
        [self presentViewController:logInController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.tabBarController.selectedIndex = 0;
    self.welcomeLabel.text = [NSString stringWithFormat:@"你好，%@", user.username];
}

- (IBAction)buttonToTeachClicked:(id)sender {
    /*
     
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"BeTeacher"];
    [self presentViewController:vc animated:YES completion:nil];*/
    
    
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"Teach" bundle:nil];
    UIViewController* secondViewController = [secondStoryboard instantiateViewControllerWithIdentifier:@"BeTeacher"];
    
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController presentViewController: secondViewController animated:YES completion: NULL];

    
    //[self dismissViewControllerAnimated:YES completion:nil];
    

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
