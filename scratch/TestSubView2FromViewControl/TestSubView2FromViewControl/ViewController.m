//
//  ViewController.m
//  TestSubView2FromViewControl
//
//  Created by Liefu Liu on 4/2/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "ViewController.h"
#import "SubViewController.h"
#import "MySubView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated {
    //self.realView.frame = [self rectInCenter:self.view.frame.size withSize:CGSizeMake(200, 100)];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.realView.hidden = YES;
    self.view.autoresizesSubviews = YES;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (BOOL) hasSubView {
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[SubViewController class]]) {
            return YES;
        }
    }
    return NO;
}
*/

- (IBAction)showButtonClicked:(id)sender {
    /*
    SubViewController* location = [[SubViewController alloc] initWithNibName:@"SubViewController" bundle:[NSBundle mainBundle]];
    
    UIView *viewToAdd = location.view;
    self.myView = viewToAdd;
    self.myView.frame = CGRectMake(0, 100, 320, 160);
    [self.view addSubview:viewToAdd];
     */
    CGRect newFrame = [self rectInCenter:self.view.frame.size withSize:CGSizeMake(200, 100)];
    self.realView.frame = newFrame;
    self.realView.hidden = NO;
}
- (IBAction)insideHiddenButtonClicked:(id)sender {
    self.realView.hidden = YES;
}



- (IBAction)hideButtonClicked:(id)sender {
    /*
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[SubViewController class]]) {
            [view removeFromSuperview];
        }
    }*/
    // [self.myView removeFromSuperview];
    
    
    self.realView.hidden = YES;
    /*
    SubViewController* tableView1;
    if (tableView1 != nil)
    {
        tableView1 = [[SubViewController alloc] initWithNibName:@"SubViewController" bundle:nil];
    }
    
    [tableView1.view removeFormSuperview];
     */
}

@end
