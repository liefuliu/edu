//
//  BRDBackendFactory.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 3/6/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDBackendFactory.h"
#import "BRDBookLister.h"
#import "BRDBookDownloader.h"
#import "BRDConfig.h"
#import "BRDConstants.h"

#import "BRDParseBookLister.h"
#import "BRDParseBookDownloader.h"

#import "BRDLeanCloudBookLister.h"
#import "BRDLeanCloudBookDownloader.h"

@implementation BRDBackendFactory

+ (id<BRDBookLister>) getBookLister {
    if ([[BRDConfig sharedObject] backendToUse] == kBackendParse) {
        return [BRDParseBookLister sharedObject];
    } else if ([[BRDConfig sharedObject] backendToUse] == kBackendLeanCloud) {
        return [BRDLeanCloudBookLister sharedObject];
    }
    return nil;
}

+ (id<BRDBookDownloader>) getBookDownloader {
    if ([[BRDConfig sharedObject] backendToUse] == kBackendParse) {
        return [BRDParseBookDownloader sharedObject];
    } else if ([[BRDConfig sharedObject] backendToUse] == kBackendLeanCloud) {
        return [BRDLeanCloudBookDownloader sharedObject];
    }
    return nil;
    
}

@end
