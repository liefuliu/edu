//
//  SRXColor.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/29/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXColor.h"

@implementation SRXColor


+ (UIColor*) colorForSignUp {
    return [[UIColor alloc] initWithRed:0.5 green:0.25 blue:0.25 alpha:1.0];
}

+ (UIColor*) colorForSignUpLowlighted {
    return [[UIColor alloc] initWithRed:0.5 green:0.25 blue:0.25 alpha:0.5];
}

+ (UIColor*) colorForLogIn {
    return [[UIColor alloc] initWithRed:0 green:0.5 blue:0.5 alpha:1.0];
}

+ (UIColor*) colorForLogInLowlighted {
    return [[UIColor alloc] initWithRed:0 green:0.5 blue:0.5 alpha:0.5];
}

+ (UIColor*) colorForWeixinLogIn {
    return [[UIColor alloc ]initWithRed:0.25 green:0.625 blue:0.25 alpha:1.0];
}


+ (UIColor*) colorForWeixinLogInDisabled {
    return [[UIColor alloc ]initWithRed:0.25 green:0.625 blue:0.25 alpha:0.5];
}

+ (UIColor*) colorForLogOut {
    return [[UIColor alloc ]initWithRed:0.5 green:0.25 blue:0.25 alpha:1.0];

}

+ (UIColor*) colorForIWantToTeach {
    return [[UIColor alloc ]initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
}
@end
