//
//  BRDConfig.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/21/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "BRDConfig.h"

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
    }
    return self;
}

@end
