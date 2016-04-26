//
//  LocalBook.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/25/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalBook : NSObject <NSCoding>

// 绘本书名
@property NSString* bookName;

// 绘本的作者
@property NSString* author;

// 绘本总共的页数
@property int totalPages;

// 已经下载完成的页数
@property int downloadedPages;

// 书本的文件名
@property NSString* filePrefix;

// 是否包含翻译
@property BOOL hasTranslatedText;

- (id) initBook:(NSString*) bookName
         author:(NSString*) author
     totalPages:(int) totalPages
downloadedPages:(int) downloadedPages
     filePrefix:(NSString*) filePrefix
hasTranslatedText:(BOOL) hasTranslatedText;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)encoder;



@end
