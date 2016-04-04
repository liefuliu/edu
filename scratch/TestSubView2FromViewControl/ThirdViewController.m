//
//  ThirdViewController.m
//  TestSubView2FromViewControl
//
//  Created by Liefu Liu on 4/3/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "ThirdViewController.h"
#import "ThirdSubVC.h"

@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;


@property UIView* myView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self hidePopupButton:YES];
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
- (IBAction)showButtonClicked:(id)sender {
    if (self.myView == nil) {
        ThirdSubVC* location = [[ThirdSubVC alloc] initWithNibName:@"ThirdSubVC" bundle:[NSBundle mainBundle]];
        
        self.myView = location.view;
        self.myView.frame =  self.view.frame;
        [self.view addSubview:self.myView];
        
        [self hidePopupButton:NO];
    }
    
    
}
- (IBAction)button3Clicked:(id)sender {
    [self.myView removeFromSuperview];
    [self hidePopupButton:YES];
    self.myView = nil;
}

- (void) hidePopupButton:(BOOL) hide {
    if (hide) {
        
    } else {
        [self.view bringSubviewToFront:self.button1];
        
        [self.view bringSubviewToFront:self.button2];
        
        [self.view bringSubviewToFront:self.button3];
    }
    
    
    [self.button1 setHidden:hide];
        [self.button2 setHidden:hide];
        [self.button3 setHidden:hide];
}

@end
