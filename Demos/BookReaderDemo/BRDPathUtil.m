//
//  BRDPathUtil.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/25/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDPathUtil.h"

@implementation BRDPathUtil

+ (NSString*) extractParseFileName: (NSString*) parseFilePath {
    NSArray *bits = [parseFilePath componentsSeparatedByString: @"20160117_211559_"];
    NSString* fileName = (NSString*)bits[[bits count] - 1];
    return fileName;
}

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

+ (NSString*) applicationDocumentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*) convertToDocumentPath: (NSString*) parseFilePath {
    NSString *fileName = [self extractParseFileName:parseFilePath];
    NSString *path = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString*) resourceBundleDirectory {
    return [[NSBundle mainBundle] resourcePath];
}

@end
