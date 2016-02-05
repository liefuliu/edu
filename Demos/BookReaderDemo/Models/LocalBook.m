//
//  LocalBook.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/25/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//
#import "BRDPathUtil.h"
#import "LocalBook.h"

@implementation LocalBook


- (id) initBook:(NSString*) bookName
         author:(NSString*) author
     totalPages:(int) totalPages
     filePrefix:(NSString*) filePrefix
hasTranslatedText:(BOOL) hasTranslatedText {
    self = [super init];
    if (self) {
        _bookName = bookName;
        _author = author;
        _totalPages = totalPages;
        _filePrefix = filePrefix;
        _hasTranslatedText = hasTranslatedText;
    }
    return self;
}

+ (NSArray*) extractTranslatedText: (NSString*) bookKey {
    NSString* filePath = [NSString stringWithFormat:@"%@/%@-trans.txt",
                          [BRDPathUtil applicationDocumentsDirectoryPath],
                          bookKey];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding error:nil];
    
    
    NSArray* allLinedStrings =
    [fileContents componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray* translatedText = [[NSMutableArray alloc] init];
    for (NSString* encodedLine in allLinedStrings) {
        [translatedText addObject:[encodedLine stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
    }

    return translatedText;
}

@end
