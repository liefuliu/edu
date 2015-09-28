//
//  SRXClassUtil.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/27/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXClassUtil.h"

@implementation SRXClassUtil


+ (NSDictionary*) getClassDescriptiveDictionary {
    // TODO: improve this function to ensure diction is created only once.
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if (dict) {
        [dict setObject:NSLocalizedString(@"Chinese", nil) forKey:[NSNumber numberWithInt:SRXDataClassTypeEnumSRXDataClassTypeYuwen]];
        [dict setObject:NSLocalizedString(@"Math", nil) forKey:[NSNumber numberWithInt:SRXDataClassTypeEnumSRXDataClassTypeShuxue]];
        [dict setObject:NSLocalizedString(@"Weiqi", nil) forKey:[NSNumber numberWithInt:SRXDataClassTypeEnumSRXDataClassTypeWeiqi]];
        [dict setObject:NSLocalizedString(@"Piano", nil) forKey:[NSNumber numberWithInt:SRXDataClassTypeEnumSRXDataClassTypeGangqin]];
    }
    
    return dict;
}

@end
