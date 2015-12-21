//
//  SRXSingleTextInputVC.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 12/13/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXSingleTextInputVC.h"

@interface SRXSingleTextInputVC ()

@end

@implementation SRXSingleTextInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


- (id) initWithTitle:(NSString*) title
      withDelegateId: (int) delegateId {
    [super init];
    
    if (self) {
    self.labelTitle = title;
    self.delegateId = delegateId;
    }
    
    return self;
}


@end
