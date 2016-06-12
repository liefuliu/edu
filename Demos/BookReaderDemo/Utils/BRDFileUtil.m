//
//  BRDFileUtil.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/5/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDFileUtil.h"
#import "BRDPathUtil.h"
#import "BRDConstants.h"

@implementation BRDFileUtil


+ (NSArray*) extractTranslatedText: (NSString*) bookKey {
    NSString* filePath = [NSString stringWithFormat:@"%@/%@-trans.txt",
                          [BRDPathUtil applicationDocumentsDirectoryPath],
                          bookKey];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding error:nil];
    
    
    NSArray* allLinedStrings =
    [fileContents componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    allLinedStrings = [allLinedStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    NSMutableArray* translatedText = [[NSMutableArray alloc] init];
    for (NSString* encodedLine in allLinedStrings) {
        [translatedText addObject:[encodedLine stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
    }
    
    return translatedText;
}


+ (NSData*) getBookCoverImage: (NSString*) bookKey {
    NSString* documentsDirectory = [BRDPathUtil applicationDocumentsDirectoryPath];
    NSString* fileName = [NSString stringWithFormat:@"%@-cover.jpg",
                          bookKey]; // 绘本页从1开始计数。
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return [NSData dataWithContentsOfFile:filePath];
}

+ (NSData*) getBookImage: (NSString*) bookKey
                  onPage: (int) pageIndex
           imageFileType: (int) imageFileType {
    // 这个函数只负责将文件读入数据，不负责解析。
    if (imageFileType == kImageFileFormatJpg || imageFileType == kImageFileFormatPdf) {
        NSString* imageFileName;

        if (imageFileType == kImageFileFormatJpg) {
            imageFileName = [NSString stringWithFormat:@"%@-picture-%@.jpg",
                          bookKey,
                          [BRDFileUtil intToString:pageIndex+1]]; // 绘本页从1开始计数。
        } else {
            imageFileName = [NSString stringWithFormat:@"%@-picture-%@.pdf",
                             bookKey,
                             [BRDFileUtil intToString:pageIndex+1]]; // 绘本页从1开始计数。
        }

        NSString* documentsDirectory = [BRDPathUtil applicationDocumentsDirectoryPath];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageFileName];
        return [NSData dataWithContentsOfFile:filePath];
    } else {
        return nil;
    }
}

#pragma mark - private functions


+ (NSString*) intToString:(int) integer {
    if (integer < 10) {
        return [NSString stringWithFormat:@"000%d", integer];
    } else if (integer < 100) {
        return [NSString stringWithFormat:@"00%d", integer];
    } else if (integer < 1000) {
        return [NSString stringWithFormat:@"0%d", integer];
    } else {
        return [NSString stringWithFormat:@"%d", integer];
    }
}

@end
