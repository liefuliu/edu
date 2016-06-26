//
//  BRDConfig.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/21/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "BRDConfig.h"
#import "BRDConstants.h"

@implementation BRDConfig

+ (id)sharedObject {
    static BRDConfig *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[self alloc] init];
    });
    return object;
}

- (id)init {
    if (self = [super init]) {
        _useScrollViewInPagination = true;
        _backendToUse = kBackendLeanCloud; //kBackendParse;
        _directlyOpenBookPages = true;
    }
    return self;
}

@end
