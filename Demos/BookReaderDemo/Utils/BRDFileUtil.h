//
//  BRDFileUtil.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/5/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDFileUtil : NSObject

+ (NSArray*) extractTranslatedText: (NSString*) bookKey;

+ (NSData*) getBookCoverImage: (NSString*) bookKey;

+ (NSData*) getBookImage: (NSString*) bookKey
                      onPage: (int) pageIndex
           imageFileType:(int) imageFileType;

@end
