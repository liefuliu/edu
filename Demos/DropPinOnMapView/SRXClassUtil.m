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
    // TODO: Use the key to be enum and the default value to be English translation
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if (dict) {
        [dict setObject:NSLocalizedString(@"SRXDataClassTypeEnumSRXDataClassTypeYuwen", @"Chinese")
                 forKey:[NSNumber numberWithInt:SRXDataClassTypeEnumSRXDataClassTypeYuwen]];
        [dict setObject:NSLocalizedString(@"SRXDataClassTypeEnumSRXDataClassTypeShuxue", @"Math")
                 forKey:[NSNumber numberWithInt:SRXDataClassTypeEnumSRXDataClassTypeShuxue]];
        [dict setObject:NSLocalizedString(@"SRXDataClassTypeEnumSRXDataClassTypeWeiqi", @"Weiqi")
                 forKey:[NSNumber numberWithInt:SRXDataClassTypeEnumSRXDataClassTypeWeiqi]];
        [dict setObject:NSLocalizedString(@"SRXDataClassTypeEnumSRXDataClassTypeGangqin", @"Piano")
                 forKey:[NSNumber numberWithInt:SRXDataClassTypeEnumSRXDataClassTypeGangqin]];
    }
    
    return dict;
}

@end
