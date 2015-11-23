//
//  SRXStartVC.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 11/8/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXStartVC.h"

#import "SRXSingleSelectionTableViewController.h"

#import "UIViewController+Charleene.h"
#import "SRXEnvironment.h"

@interface SRXStartVC () <SRXSingleSelectionTableViewControllerDelegate>

@property BOOL firstTiemeLoad;

@end

@implementation SRXStartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _firstTiemeLoad = YES;
    
}

- (void) viewDidAppear:(BOOL)animated {
    if (_firstTiemeLoad) {
        _firstTiemeLoad = NO;
        
        NSMutableArray* startingModes = [[NSMutableArray alloc] init];
        [startingModes addObject:NSLocalizedString(@"I'm a student", nil)];
        [startingModes addObject:NSLocalizedString(@"I'm a teacher", nil)];
        
        SRXSingleSelectionTableViewController* selectionViewController = [[SRXSingleSelectionTableViewController alloc] initWithTitle:@""
                                                                                                                    Items:startingModes];
        
        selectionViewController.delegate = self;
        selectionViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        selectionViewController.modalPresentationStyle =  UIModalPresentationFormSheet;
        
        CGPoint frameSize = CGPointMake([[UIScreen mainScreen] bounds].size.width*0.45f, [[UIScreen mainScreen] bounds].size.height*0.45f);
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        // Resizing for iOS 8
        selectionViewController.preferredContentSize = CGSizeMake(frameSize.x, frameSize.y);
        // Resizing for <= iOS 7
        selectionViewController.view.superview.frame = CGRectMake((screenWidth - frameSize.x)/2, (screenHeight - frameSize.y)/2, frameSize.x, frameSize.y);
        
        [self presentCharleeneModally:selectionViewController transitionMode:KSModalTransitionModeFromRight];
        //[self presentViewController:selectionViewController animated:YES completion:nil];
    }
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

-(void) itemDidSelectAt: (int)selectedItemIndex
            withContent: (NSString*) selectedItem {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (selectedItemIndex == 0) {
        [[SRXEnvironment sharedObject] setStartingMode:SRXStartingModeStudent];

        UIViewController* secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BeStudent"];
        [self presentViewController:secondViewController animated:NO completion:nil];
    } else {
        [[SRXEnvironment sharedObject] setStartingMode:SRXStartingModeTeacher];
        
        UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"Teacher" bundle:nil];
        UIViewController* secondViewController = [secondStoryboard instantiateViewControllerWithIdentifier:@"TeacherMainView"];
        [self presentViewController:secondViewController animated:YES completion:nil];
    }
}
@end
