//
//  FileValidator.h
//  ParseBookUploader
//
//  Created by Liefu Liu on 7/5/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>


enum BUErrorType {
    kErrorUnknown,
    kErrorCoverOversize,
    kErrorImageOversize,
    kErrorMultiBookIdFound
    
};

enum BUWarningType {
    kWarningLargePageFound,
    kWarningTranslationNotFound,
    kWarningCoverNotFound
};

@interface BUWarning : NSObject
@property enum BUWarningType warningType;
@property NSString* summary;
- (id) init: (enum BUWarningType) warningType
withSummary: (NSString*) summary;
@end

@interface BUError : NSObject
@property enum BUErrorType errorType;
@property NSString* summary;

- (id) init: (enum BUErrorType) errorType
withSummary: (NSString*) summary;

@end


@interface FileValidator : NSObject


+ (BOOL) validateFiles:(NSArray*) filesToUpload
              errorsTo:(NSArray**) errors
            warningsTo:(NSArray**) warnings;

@end
