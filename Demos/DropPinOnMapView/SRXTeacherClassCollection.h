//
//  SRXTeacherClassCollection.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/6/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassInfo.h"

@interface SRXTeacherClassCollection : NSObject

@property (readonly) NSMutableArray* classCollection;

- (void) addClass: (ClassInfo*) classInfo;

// Temporary function used for demo only.
+(SRXTeacherClassCollection*) sharedClassCollectionForDemo;

@end
