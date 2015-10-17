//
//  ViewController.m
//  TestTeacher
//
//  Created by Liefu Liu on 8/21/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseUI/PFLogInViewController.h>

@interface ViewController () <PFLogInViewControllerDelegate>

@end

@implementation ViewController

- (void) viewDidAppear:(BOOL)animated {
    //[PFUser logOut];
    PFUser *user = [PFUser currentUser];
    NSLog(@"PFUser: %@", user);
    if(user == nil) {
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    [self presentViewController:logInController animated:YES completion:nil];
    }
}

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    PFObject *testObject = [PFObject objectWithClassName:@"MarriageOjbect2"];
    
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"test object created success");
             self.objectId = testObject.objectId;
        } else {
            NSLog(@"Failed to create object");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addMarriage:(id)sender {
    if (![self.boyQuestionText.text isEqualToString:@""] && ![self.girlQuestionText.text isEqualToString:@""] ) {
        
    
        PFQuery *query = [PFQuery queryWithClassName:@"MarriageOjbect2"];
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:self.objectId
                                     block:^(PFObject *gameScore, NSError *error) {
                                         // Now let's update it with some new data. In this case, only cheatMode and score
                                         // will get sent to the cloud. playerName hasn't changed.
                                         gameScore[self.boyQuestionText.text] = self.girlQuestionText.text;
                                         [gameScore saveInBackground];
                                         
                                         if (error) {
                                             NSLog(@"error: %@", error);
                                             
                                         } else {
                                             NSLog(@"Successfully saved [%@, %@]", self.boyQuestionText.text, self.girlQuestionText.text);
                                         }
                                     }];
   }
}

- (IBAction)lookupMarrage:(id)sender {
    if (![self.boyAnswerText.text isEqualToString:@""]) {
        PFQuery *query = [PFQuery queryWithClassName:@"MarriageOjbect2"];
        [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *marriageObject, NSError *error) {
            NSLog(@"marraigeObject: %@", marriageObject);
            // Do something with the returned PFObject in the gameScore variable.
            NSString* girlName = [marriageObject objectForKey:self.boyAnswerText.text ];
            
            NSLog(@"boy:%@ girl:%@", self.boyAnswerText.text,  girlName);
            self.girlAnswerText.text = girlName;
            
            
        }];
    }
}
@end
