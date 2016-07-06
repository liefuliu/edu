//
//  FileValidator.h
//  ParseBookUploader
//
//  Created by Liefu Liu on 7/5/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileValidator : NSObject


+ (BOOL) validateFiles:(NSArray*) filesToUpload
              errorsTo:(NSArray**) errors
            warningsTo:(NSArray**) warnings;

@end
