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

// TODO(liefuliu):
// Consolidate this class with LocalBook class, which are doing the same things.
@interface BRDListedBook : NSObject<NSCoding>

@property NSString* bookId;
@property NSString* bookName;
@property NSString* bookNotes;
@property NSString* author;
@property NSData* cover;
@property int totalPages;

// TODO(liefuliu): Add
@property int imageFileType;

- (id) initBook:(NSString*) bookId
           name:(NSString*) bookName
         author:(NSString*) author
      bookNotes:(NSString*) bookNotes
     totalPages:(int) totalPages
          cover:(NSData*) cover
  imageFileType:(int) imageFileType;


@end
