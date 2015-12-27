//
//  LocalBook.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/25/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalBook : NSObject

@property NSString* bookName;
@property NSString* author;
@property int totalPages;
@property NSString* filePrefix;
@property NSArray* translatedText;

- (id) initBook:(NSString*) bookName
         author:(NSString*) author
     totalPages:(int) totalPages
     filePrefix:(NSString*) filePrefix
 translatedText:(NSString*) translatedText;

@end
