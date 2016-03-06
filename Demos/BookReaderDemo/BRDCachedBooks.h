//
//  BRDCachedBooks.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/25/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRDCachedBooks : NSObject <NSCoding>

@property NSArray* bookList;  // of BRDListedBook
@property NSDictionary* bookCoverImages; // of BRDBookSummary

-(id) initWithBookList:(NSArray*)bookList
       withCovers:(NSDictionary*)bookCoverImages;

@end
