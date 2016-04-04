//
//  SubVC.h
//  TestSubView
//
//  Created by Liefu Liu on 3/27/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *popUpView;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
