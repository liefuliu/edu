//
//  ViewController.h
//  TestSubView2FromViewControl
//
//  Created by Liefu Liu on 4/2/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) UIView* myView;
@property (weak, nonatomic) IBOutlet UIView *realView;

@end

