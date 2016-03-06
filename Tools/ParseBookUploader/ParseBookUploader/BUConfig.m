//
//  BUConfig.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 3/6/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BUConfig.h"
#import "BUConstants.h"

@implementation BUConfig

+ (int) getBackendToUse {
    return kBackendLeanCloud;
}

@end
