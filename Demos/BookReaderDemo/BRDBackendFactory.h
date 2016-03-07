//
//  BRDBackendFactory.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 3/6/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRDBookLister.h"
#import "BRDBookDownloader.h"

@interface BRDBackendFactory : NSObject

+ (id<BRDBookLister>) getBookLister;

+ (id<BRDBookDownloader>) getBookDownloader;

@end
