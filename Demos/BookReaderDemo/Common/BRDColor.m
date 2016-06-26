//
//  BRDColor.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 5/8/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//
#import "BRDColor.h"

@implementation BRDColor

// Lake blue
+ (UIColor*) backgroundLakeBlue {
    UIColor* color = [UIColor colorWithRed:(26.0f/255.0f) green:(155/255.0f) blue:(192.0f/255.0f) alpha:1.0f];
    return color;
}

+ (UIColor*)backgroundOceanBlue {
    UIColor* color = [UIColor colorWithRed:(50.0/255.0f) green:(119/255.0f) blue:(190.0f/255.0f) alpha:1.0f];
    return color;
}


+ (UIColor*)backgroundSteelBlue {
    UIColor* color = [UIColor colorWithRed:(70.0/255.0f) green:(130/255.0f) blue:(180.0f/255.0f) alpha:1.0f];
    return color;
}


+ (UIColor*)backgroundSRXBlue {
    UIColor* color = [UIColor colorWithRed:(0.0/255.0f) green:(153/255.0f) blue:(225.0f/255.0f) alpha:1.0f];
    return color;
}


+ (UIColor*) backgroundSkyBlue {
    return [BRDColor backgroundSRXBlue];
}

+ (UIColor*) lowlightTextGrayColor {
    UIColor* color = [UIColor colorWithRed:(0.75) green:(0.75) blue:(0.75) alpha:1.0f];
    return color;
}


@end
