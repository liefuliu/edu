//
//  BRDPathUtil.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/25/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDPathUtil : NSObject

+ (NSString*) extractParseFileName: (NSString*) parseFilePath;

+ (NSURL*) applicationDocumentsDirectory;

+ (NSString*) applicationDocumentsDirectoryPath;

+ (NSString*) resourceBundleDirectory;

+ (NSString*) convertToDocumentPath: (NSString*) parseFilePath;

@end
