//
//  FileValidator.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 7/5/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "FileValidator.h"
#import "FilePathUtil.h"

@implementation FileValidator

const unsigned long long kMaxCoverFileSize = 100 * 1024; // 100 KB

const NSString* kErrorCoverFileTooBig = @"Cover文件大小不能超过 100 KB";

+ (BOOL) validateFiles:(NSArray*) filesToUpload
              errorsTo:(NSArray**) errors
            warningsTo:(NSArray**) warnings {
    NSMutableArray* newErrors = [[NSMutableArray alloc] init];
    NSMutableArray* newWarnings = [[NSMutableArray alloc] init];
    
    BOOL result = true;
    
    result &= [FileValidator validateCoverFiles:filesToUpload
                    errorsTo:newErrors
                    warningsTo:newWarnings];
    
    *errors = newErrors;
    *warnings = newWarnings;
    return result;
}

+ (BOOL) validateCoverFiles:(NSArray*) filesToUpload
              errorsTo:(NSMutableArray*) errors
            warningsTo:(NSMutableArray*) warnings {
    for (NSString* file in filesToUpload) {
        NSString* fileName = [file lastPathComponent];
        if ([FilePathUtil getFileType:fileName] == kCover) {
            NSError* error;
            NSString* fileCopy = [NSString stringWithFormat:@"%@", file];
            NSString* filePath = [fileCopy stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            NSDictionary<NSString *,id> *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath                                                                                  error:&error];
            if (error != nil) {
                NSLog(@"%@", error);
                return NO;
            }
            unsigned long long fileSize = [dict fileSize];
            if (fileSize > kMaxCoverFileSize) {
                [errors addObject:[NSString stringWithFormat:@"%@: %@", kErrorCoverFileTooBig, fileCopy]];
                return NO;
            }

        }
    }
    
    return YES;
}

@end
