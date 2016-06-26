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
@property (readonly) int backendToUse;

// 在绘本馆点击书本后，直接进入绘本页，不显示下载进度。
@property (readonly) bool directlyOpenBookPages;

+ (id) sharedObject;



@end
