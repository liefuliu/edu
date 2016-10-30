//
//  FileValidator.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 7/5/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "FileValidator.h"
#import "FilePathUtil.h"



@implementation BUWarning
- (id) init: (enum BUWarningType) warningType
withSummary: (NSString*) summary {
    self = [super init];
    if (self) {
        self.warningType = warningType;
        self.summary = summary;
    }
    return self;
}
@end

@implementation BUError

- (id) init: (enum BUErrorType) errorType
withSummary: (NSString*) summary {
    self = [super init];
    if (self) {
        self.errorType = errorType;
        self.summary = summary;
    }
    return self;
}
@end



@implementation FileValidator

const unsigned long long kMaxCoverFileSize = 100 * 1024; // 100 KB
const unsigned long long kMaxImageFileSize = 400 * 1024;

const NSString* kErrorCoverFileTooBig = @"文件大小不能超过 100 KB";


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
    BOOL coverFileFound = NO;
    BOOL translationFileFound = NO;
    
    for (NSString* file in filesToUpload) {
        NSString* fileName = [file lastPathComponent];
        int fileType = [FilePathUtil getFileType:fileName];
        if (fileType == kCover) {
            int fileSize = [FileValidator getFileSize:file];
            if (fileSize < 0) {
                NSString* errorDescription = [NSString stringWithFormat:@"文件读取错误(%@)", fileName];
                [errors addObject:[[BUError alloc ]init:kErrorUnknown withSummary:errorDescription]];
            } else if (fileSize > kMaxCoverFileSize) {
                NSString* errorDescription = [NSString stringWithFormat:@"封面文件(%@)大小超过100KB", fileName];
                [errors addObject:[[BUError alloc ]init:kErrorCoverOversize withSummary:errorDescription]];
            }
            coverFileFound = YES;
        } else if (fileType == kImage) {
            int fileSize = [FileValidator getFileSize:file];
            if (fileSize < 0) {
                NSString* errorDescription = [NSString stringWithFormat:@"文件读取错误(%@)", fileName];
                [errors addObject:[[BUError alloc ]init:kErrorUnknown withSummary:errorDescription]];
            } else if (fileSize > kMaxImageFileSize) {
                NSString* errorDescription = [NSString stringWithFormat:@"绘本页文件(%@)大小超过400KB", fileName];
                [errors addObject:[[BUError alloc ]init:kErrorImageOversize withSummary:errorDescription]];
            }
        } else if (fileType == kTranslation) {
            translationFileFound = YES;
        }
    }
    
    if (!coverFileFound) {
        NSString* warningDescription = @"缺少封面文件(*-cover.jpg)";
        [warnings addObject:[[BUWarning alloc] init:kWarningCoverNotFound withSummary:warningDescription]];
    }
    if (!translationFileFound) {
        NSString* warningDescription = @"缺少翻译文件(*-trans.txt)";
        [warnings addObject:[[BUWarning alloc] init:kWarningTranslationNotFound withSummary:warningDescription]];
    }
    
    return [errors count] == 0;
}

+ (int) getFileSize:(NSString*) file {
    NSString* fileCopy = [NSString stringWithFormat:@"%@", file];
    NSString* filePath = [fileCopy stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    
    NSError* error;
    NSDictionary<NSString*,id> *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath                                                                                  error:&error];
    if (error != nil) {
        return -1;
    }
    return [dict fileSize];
}





@end
