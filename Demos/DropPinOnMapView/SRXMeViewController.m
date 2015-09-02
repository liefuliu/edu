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
#import "SRXLogInSignUpViewController.h"
#import "SRXColor.h"
#import "SRXUserInfoKeys.h"

@interface SRXMeViewController ()

@end

@implementation SRXMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[PFUser logOut];
}

- (void) viewDidAppear:(BOOL)animated {
    //[self popupLogInWindowIfNotSigned];
    
    // [self popupLogInWindowIfNotSigned];
    // The function is entered before the window closed.
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self initializeColor];
    [self reload];
}

- (void) initializeColor {
    self.buttonLogIn.backgroundColor = [SRXColor colorForLogIn];
    self.buttonLogOut.backgroundColor = [SRXColor colorForLogOut];
    self.buttonIWantToTeach.backgroundColor = [SRXColor colorForIWantToTeach];
}

- (void) reload {
    PFUser *user = [PFUser currentUser];
    NSLog(@"current user: %@", user);
    if (user == nil) {
        // REMOVE self.tabBarController.selectedIndex = 0;
        self.welcomeLabel.hidden = YES;
        self.buttonLogIn.hidden = NO;
        self.buttonLogOut.hidden = YES;
        self.buttonIWantToTeach.hidden = YES;
        
    } else {
        // REMOVE self.tabBarController.selectedIndex = 1;
        self.welcomeLabel.hidden = NO;
        self.welcomeLabel.text = [NSString stringWithFormat:@"你好，%@",[self getUserDisplayName:user]];
        self.buttonLogIn.hidden = YES;
        self.buttonLogOut.hidden = NO;
        self.buttonIWantToTeach.hidden = NO;
    }
}

- (NSString*) getUserDisplayName: (PFUser*) user {
    if (user[UserInfoKey_PersonName] != nil) {
        return user[UserInfoKey_PersonName];
    } else {
        return user.username;
    }
}
                                  

- (IBAction)buttonLogInTouched:(id)sender {
    SRXLogInSignUpViewController* myLogInController = [[SRXLogInSignUpViewController alloc] init];
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:myLogInController];
    [self presentViewController:navController animated:YES completion:^{}];
    [self reload];
    //[self.view setNeedsDisplay];
}

- (IBAction)buttonLogOutTouched:(id)sender {
   [PFUser logOut];
    [self reload];
   //[self.view setNeedsDisplay];
}

- (void) popupLogInWindowIfNotSigned {
    PFUser *tempUser = [PFUser currentUser];
    NSLog(@"PFUser: %@", tempUser);
    if(tempUser == nil) {
        SRXLogInSignUpViewController* myLogInController = [[SRXLogInSignUpViewController alloc] init];
        
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:myLogInController];
        [self presentViewController:navController animated:YES completion:^{}];
    } else {
        self.welcomeLabel.text = [NSString stringWithFormat:@"你好，%@", tempUser.username];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonToTeachClicked:(id)sender {
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"Teach" bundle:nil];
    UIViewController* secondViewController = [secondStoryboard instantiateViewControllerWithIdentifier:@"BeTeacher"];
    
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController presentViewController: secondViewController animated:YES completion: NULL];
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
