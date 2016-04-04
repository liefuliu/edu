//
//  ViewController.m
//  TestSubView
//
//  Created by Liefu Liu on 3/27/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "ViewController.h"
#import "SubVC.h"
@interface ViewController ()

@property int initialViewCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.initialViewCount = self.addViewToAddPlot.subviews.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect) getZoomedRect: (CGRect) rect
               withScale:(float)scale {
    CGPoint centerPoint = CGPointMake(
        rect.origin.x + rect.size.width / 2.0,
        rect.origin.y + rect.size.height / 2.0);
    
    CGRect newRect;
    newRect.size.width = rect.size.width * scale;
    
    newRect.size.height = rect.size.height * scale;
    
    newRect.origin.x =centerPoint.x - newRect.size.width / 2;
    newRect.origin.y = centerPoint.y - newRect.size.height / 2;
    
    return newRect;
    
}



- (IBAction)buttonOpenClicked:(id)sender {
    /*
    if (self.subViewPopup) {
        return;
    }*/
    
    NSLog(@"Hello. self.addViewToAddPlot view count %d", self.addViewToAddPlot.subviews.count);
    
    if (self.addViewToAddPlot.subviews.count > self.initialViewCount) {
        return;
    }
    
    SubVC* subVC = [[SubVC alloc] init];
    /*
    [subVC showInView:self.view animated:YES];
     */
    
    // subVC.view.frame = self.addViewToAddPlot.bounds;
    
    subVC.view.frame = [self getZoomedRect:self.view.bounds
                                 withScale:0.33];
    
    
    [self.addViewToAddPlot addSubview:subVC.view];
    [self addChildViewController:subVC];
    [subVC didMoveToParentViewController:self];
    
}

@end
