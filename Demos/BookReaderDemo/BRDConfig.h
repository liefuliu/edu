//
//  BRDConfig.h
//  BookReaderDemo
//
//  包含App所有的Configuration.
//
//  Created by Liefu Liu on 12/21/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDConfig : NSObject

@property (readonly) bool useScrollViewInPagination;

+ (id) sharedObject;



@end
