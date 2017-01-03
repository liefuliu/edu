//
//  ShadowUtil.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/2/17.
//  Copyright © 2017 SanRenXing. All rights reserved.
//

#import "ShadowUtil.h"

@implementation ShadowUtil

+ (void) setShadowToLayer: (CALayer*) layer {
    [layer setShadowColor:[UIColor blackColor].CGColor];
    [layer setShadowOpacity:0.8];
    [layer setShadowRadius:3.0];
    [layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}


@end
