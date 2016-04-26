//
//  LocalBookStatus.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/25/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalBookStatus : NSObject<NSCoding>

// 上一次读到第几页
@property int pageLastRead;

// 最近一次阅读的时间
@property NSDate* lastReadDate;

@end
