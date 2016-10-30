//
//  FilePathUtil.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 1/17/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "FilePathUtil.h"

@implementation FilePathUtil

+ (NSString*) getBookName:(NSString*) fileName {
    NSArray *bits = [fileName componentsSeparatedByString: @"-"];
    return bits[0];
}

+ (int) getPageNumber:(NSString*) fileName {
    NSArray *bits = [fileName componentsSeparatedByString: @"-"];
    if ([bits count] < 3) {
        NSLog(@"fileName is not valid: %@", fileName);
    }
    NSString* pageString = [(NSString*)bits[2] stringByDeletingPathExtension];
    return [pageString intValue];
}

+ (int) getFileType:(NSString*) fileName {
    NSString *imageRegexp = @"[a-zA-Z0-9]+\\-picture\\-[0-9][0-9][0-9][0-9]\\.jpg";
    NSPredicate *imageRegexpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", imageRegexp];
    if ([imageRegexpTest evaluateWithObject: fileName]){
        return kImage;
    }
    
    NSString *audtioRegexp = @"[a-zA-Z0-9]+\\-audio\\-[0-9][0-9][0-9][0-9]\\.mp3";
    NSPredicate *audtioRegexpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", audtioRegexp];
    if ([audtioRegexpTest evaluateWithObject: fileName]){
        return kAudio;
    }

    
    NSString *coverRegexp = @"[a-zA-Z0-9]+\\-cover\\.jpg";
    NSPredicate *coverRegexpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", coverRegexp];
    if ([coverRegexpTest evaluateWithObject: fileName]){
        return kCover;
    }
    
    NSString *translationRegexp = @"[a-zA-Z0-9]+\\-trans\\.txt";
    NSPredicate *translationRegexpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", translationRegexp];
    if ([translationRegexpTest evaluateWithObject: fileName]){
        return kTranslation;
    }
    return kFileTypeUnknown;
    
    /*
    NSArray *bits = [fileName componentsSeparatedByString: @"."];
    NSString* fileExt = bits[[bits count] - 1];
    NSString* filePrefix = bits[0];
    

    if ([fileExt isEqualToString:@"mp3"] && [filePrefix containsString:@"audio"]) {
        return kAudio;
    } else if ([fileExt isEqualToString:@"txt"]){
        return kTranslation;
    } else if ([fileExt isEqualToString:@"jpg"] && [filePrefix hasSuffix:@"-cover"]){
        return kCover;
    } else if ([fileExt isEqualToString:@"pdf"]) {
        return kPdfFile;
    } else {
        return kFileTypeUnknown;
    }*/
    
        
}

@end
