//
//  ServerBook.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/24/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

// Represent a look listed in store.
// A listed book contains all available information about this book before this book
// gets downloaded.
// 
@interface BRDListedBook : NSObject

@property NSString* bookId;
@property NSString* bookName;
@property NSString* author;
@property NSData* cover;
@property int totalPages;

- (id) initBook:(NSString*) bookId
           name:(NSString*) bookName
         author:(NSString*) author
     totalPages:(int) totalPages
          cover:(NSData*) cover;

@end
