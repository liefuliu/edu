//
//  BRDColor.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 5/8/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//  For more colors, please see:
//  http://www.tayloredmktg.com/rgb/#BL

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


+ (UIColor*)backgroundDarkSkyBlue {
    UIColor* color = [UIColor colorWithRed:(0.0/255.0f) green:(48/255.0f) blue:(96/255.0f) alpha:1.0f];
    return color;
}

/*
+ (UIColor*)backgroundIndianRed {
    UIColor* color = [UIColor colorWithRed:(205/255.0f) green:(92/255.0f) blue:(92/255.0f) alpha:1.0f];
    return color;
}
*/


+ (UIColor*)backgroundLightCoral {
    UIColor* color = [UIColor colorWithRed:(240/255.0f) green:(128/255.0f) blue:(128/255.0f) alpha:1.0f];
    return color;
}


+ (UIColor*)backgroundFlowerBlue {
    UIColor* color = [UIColor colorWithRed:(100/255.0f) green:(149/255.0f) blue:(237/255.0f) alpha:1.0f];
    return color;
}


+ (UIColor*)backgroundDimGray {
    UIColor* color = [UIColor colorWithRed:(64/255.0f) green:(64/255.0f) blue:(64/255.0f) alpha:1.0f];
    return color;
}

+ (UIColor*) backgroundSkyBlue {
    return [BRDColor backgroundLightCoral];
}


+ (UIColor*) tabBarBackground {
    return [BRDColor backgroundLightCoral];
}

+ (UIColor*) lowlightTextGrayColor {
    UIColor* color = [UIColor colorWithRed:(0.75) green:(0.75) blue:(0.75) alpha:1.0f];
    return color;
}


+ (UIColor*) greenColor {
    return [UIColor colorWithRed:0 green:0.8 blue:0.3 alpha:1.0];
}


+ (UIColor*) translationBarBackground {
    return [BRDColor backgroundDimGray];
}




@end
