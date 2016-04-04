//
//  SecondViewController.m
//  TestSubView2FromViewControl
//
//  Created by Liefu Liu on 4/3/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "SecondViewController.h"
#import "SubViewController.h"

@interface SecondViewController ()
@property UIView* myView;
@end

@implementation SecondViewController

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

- (IBAction)showClicked:(id)sender {
    if (self.myView == nil) {
    SubViewController* location = [[SubViewController alloc] initWithNibName:@"SubViewController" bundle:[NSBundle mainBundle]];
    
    self.myView = location.view;
        self.myView.frame = [self rectInCenter:self.view.frame.size withSize:CGSizeMake(200, 100)];
    [self.view addSubview:self.myView];
    }
}

- (IBAction)hideClicked:(id)sender {
    /*
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[SubViewController class]]) {
            [view removeFromSuperview];
        }
    }*/
    [self.myView removeFromSuperview];
    self.myView = nil;
}


- (CGRect) rectInCenter: (CGSize) superViewSize
               withSize: (CGSize) rectSize {
    CGRect newRect;
    newRect.size = rectSize;
    newRect.origin.x = superViewSize.width / 2 - rectSize.width / 2;
    
    newRect.origin.y = superViewSize.height / 2 -
    rectSize.height / 2;
    
    return newRect;
}




@end
