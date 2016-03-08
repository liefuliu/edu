//
//  FilePathUtil.h
//  ParseBookUploader
//
//  Created by Liefu Liu on 1/17/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

enum FileType {
    kFileTypeUnknown = 0,
    
    kImage = 1,
    
    kAudio = 2,
    
    kTranslation = 3,
    
    kCover = 4,
};

@interface FilePathUtil : NSObject

+ (NSString*) getBookName:(NSString*) fileName;
+ (int) getPageNumber:(NSString*) fileName;

+ (int) getFileType:(NSString*) fileName;

@end
