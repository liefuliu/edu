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
        NSLog(@"fileName is not valie: %@", fileName);
    }
    NSString* pageString = [(NSString*)bits[2] stringByDeletingPathExtension];
    return [pageString intValue];
}

+ (int) getFileType:(NSString*) fileName {
    NSArray *bits = [fileName componentsSeparatedByString: @"."];
    NSString* fileExt = bits[[bits count] - 1];
    
    
    if ([fileExt isEqualToString:@"mp3"]) {
        return kAudio;
    } else if ([fileExt isEqualToString:@"txt"]){
        return kTranslation;
    } else if ([fileName containsString:@"-cover."]){
        return kCover;
    } else if ([fileExt isEqualToString:@"jpg"]){
        return kImage;
    } else {
        return kFileTypeUnknown;
    }
        
}

@end
