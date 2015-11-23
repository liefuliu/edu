//
//  Course.h
//  SchoolDemo
//
//  Created by Liefu Liu on 11/1/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDReoccurence.h"
#import "SDTeacher.h"

@interface SDCourse : NSObject

@property (nonatomic) NSString* project;
@property (nonatomic) NSString* classRoom;
@property (nonatomic) int capacity;
@property (nonatomic) SDTeacher* teacher;
@property (nonatomic) SDReoccurence* reoccurence;

@end
