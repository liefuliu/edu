//
//  SRXUserAccountSuperViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/29/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXUserAccountSuperViewController.h"

@interface SRXUserAccountSuperViewController ()

@end

@implementation SRXUserAccountSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addCancelButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addCancelButton {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                     style:UIBarButtonItemStylePlain target:self
                                                                    action:@selector(cancelButtonTouched:)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void) cancelButtonTouched: (id) sender {
    NSLog(@"cancelButtonTouched called");
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
}



@end
