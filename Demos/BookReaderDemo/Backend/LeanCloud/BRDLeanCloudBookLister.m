//
//  BookHandler.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/22/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDLeanCloudBookLister.h"
#import "BRDBookSummary.h"
#import "BRDConstants.h"
#import "BRDListedBook.h"
#import "BRDListedBookSet.h"
#import <AVOSCloud/AVOSCloud.h>

@interface BRDLeanCloudBookLister()

@property NSArray* currentBookList;
@property NSArray* currentBookSetList;

@end

// TODO(liefuliu): move to BRDConstants.h
static const int MAX_BOOK_LIST = 1000;
static const int MAX_BOOK_SET_LIST = 100;
static const int MAX_BOOK_SET_TO_DISPLAY = 20;

@implementation BRDLeanCloudBookLister

+ (id)sharedObject {
    static BRDLeanCloudBookLister *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[self alloc] init];
    });
    return object;
}

- (BOOL) connectToServer {
    return YES;
}

- (BOOL) getListOfBooks:(int) numOfBooks
             startFrom:(int) pageOffset
                    to:(NSArray**) arrayOfBooks {
    
    //if (self.currentBookList == nil) {
        if (![self fetchBookList:MAX_BOOK_LIST]) {
            return NO;
        }
    //}
    
    *arrayOfBooks = [[NSMutableArray alloc] init];
    for (int i = pageOffset; i < MIN(numOfBooks + pageOffset, [self.currentBookList count]); i++) {
        [(NSMutableArray*)*arrayOfBooks addObject:self.currentBookList[i]];
    }
    
    return YES;
    
}


- (BOOL) getListOfBooks:(int) numOfBooks
              inBookSet:(NSString*) bookSetId
                     to:(NSArray**) arrayOfBooks {
    // Directly fetch the book list from the server using blocking call.
    return [BRDLeanCloudBookLister fetchBookList:MAX_BOOK_LIST withBookSetId:bookSetId to:arrayOfBooks];
}


- (BOOL) getListOfBookSets:(int) numOfBooks
                        to:(NSArray**) arrayOfBookSets  {
    if (![self fetchBookSetList:MAX_BOOK_SET_LIST]) {
        return NO;
    }
    NSMutableArray* sampleBookIdList = [[NSMutableArray alloc] init];
    for (BRDListedBookSet* bookSet in self.currentBookSetList) {
        [sampleBookIdList addObject: bookSet.sampleBookId];
    }
    
    NSDictionary* summaryInfo;
    if (![self getSummaryInfoForBooks:sampleBookIdList to:&summaryInfo]) {
        return NO;
    }

    // Fetches the first MAX_BOOK_SET_TO_DISPLAY (20) book sets and return.
    *arrayOfBookSets = [[NSMutableArray alloc] init];
    for (int i = 0; i < MIN(numOfBooks, [self.currentBookSetList count]); i++) {
        BRDListedBookSet* bookSet = self.currentBookSetList[i];
        NSData* sampleBookCoverImageData = [((BRDBookSummary*)[summaryInfo objectForKey:bookSet.sampleBookId]) imageData];
        [bookSet setSampleBookCoverImage:sampleBookCoverImageData];
        [(NSMutableArray*)*arrayOfBookSets addObject:self.currentBookSetList[i]];
        
    }
    return YES;
}

- (BOOL) getSummaryInfoForBooks: (NSArray*) arrayOfBooks
                             to: (NSDictionary**) summaryInfo {
        AVQuery *query = [AVQuery queryWithClassName:@"BookImage"];
        
    [query whereKey:@"bookId" containedIn:arrayOfBooks];
    [query whereKey:@"type" equalTo:@(kFileTypeCover).stringValue];
    
    NSArray* objects = [query findObjects];
    
    *summaryInfo = [[NSMutableDictionary alloc] init];
    
        if (objects != nil) {
            for (AVObject *object in objects) {
                AVFile* pageContent = (AVFile*) object[@"pageContent"];
                NSData* imgData = [pageContent getData];
                
                BRDBookSummary* summary = [[BRDBookSummary alloc] init];
                summary.imageData = imgData;
                [*summaryInfo setValue:summary forKey:(NSString*)object[@"bookId"]];
            }
        }
    
    return YES;
}

- (BOOL) appendSummaryInfoForBooks: (NSArray*) arrayOfBooks
                             to: (NSDictionary**) summaryInfo {
    AVQuery *query = [AVQuery queryWithClassName:@"BookImage"];
    
    [query whereKey:@"bookId" containedIn:arrayOfBooks];
    [query whereKey:@"type" equalTo:@(kFileTypeCover).stringValue];
    
    NSArray* objects = [query findObjects];
    if (objects != nil) {
        for (AVObject *object in objects) {
            AVFile* pageContent = (AVFile*) object[@"pageContent"];
            NSData* imgData = [pageContent getData];
            
            BRDBookSummary* summary = [[BRDBookSummary alloc] init];
            summary.imageData = imgData;
            [*summaryInfo setValue:summary forKey:(NSString*)object[@"bookId"]];
        }
    }
    
    return YES;
}

- (BOOL) fetchBookSetList: (int) numOfBookSets {
    AVQuery* query = [AVQuery queryWithClassName:@"BookSet"];
    NSArray* objects = [query findObjects];
    if (objects != nil) {
        NSMutableArray* bookSetArray = [[NSMutableArray alloc] init];
        for (AVObject* object in objects) {
            NSString* bookSetId = (NSString*) object[@"bookSetId"];
            NSString* bookSetName = (NSString*) object[@"bookSetName"];
            NSString* bookSetNotes = (NSString*) object[@"bookSetNotes"];
            NSString* sampleBookId = (NSString*) object[@"sampleBookId"];
            
            BRDListedBookSet* bookSet = [[BRDListedBookSet alloc] initBookSet:bookSetId
                                                                         name:bookSetName
                                                                        notes:bookSetNotes
                                                                 WithSampleBookId:sampleBookId];
            
            [bookSetArray addObject:bookSet];
        }
        self.currentBookSetList = bookSetArray;
        
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) fetchBookList: (int) numOfBooks
         withBookSetId: (NSString*) bookSetId
                    to:(NSArray**) arrayOfBooks {
    AVQuery *query = [AVQuery queryWithClassName:@"Book"];
    [query whereKey:@"isActive" equalTo:[NSNumber numberWithBool:YES]];
    if (bookSetId != nil) {
        [query whereKey:@"bookSetId" equalTo:bookSetId];
    }
    
    NSArray* objects = [query findObjects];
    NSLog(@"Successfully retrieved %d scores.", objects.count);
    
    if (objects != nil) {
        NSMutableArray* bookList = [[NSMutableArray alloc] init];
        for (AVObject *object in objects) {
            NSString* bookId = (NSString*) object[@"bookId"];
            if (bookId != nil) {
                NSString* bookName = (NSString*) object[@"bookName"];
                NSString* author = (NSString*) object[@"author"];
                NSString* bookNotes = (NSString*) object[@"bookNotes"];
                int totalPages = [((NSString*)object[@"totalPages"]) intValue];
                int imageFileType;
                NSString* imageFileTypeString = (NSString*)object[@"imageFileType"];
                if ([imageFileTypeString isEqualToString:@"pdf"]) {
                    imageFileType = kImageFileFormatPdf;
                } else if ([imageFileTypeString isEqualToString:@"jpg"]) {
                    imageFileType = kImageFileFormatJpg;
                } else {
                    imageFileType = kImageFileFormatUnknown;
                }
                
                BRDListedBook* serverBook = [[BRDListedBook alloc]
                                             initBook: bookId
                                             name: bookName
                                             author:author
                                             bookNotes:bookNotes
                                             totalPages:totalPages
                                             cover:nil
                                             imageFileType:imageFileType];
                
                [bookList addObject:serverBook];
            }
        }
        *arrayOfBooks = bookList;
        return YES;
    } else {
        return NO;
    }

    
}

+ (BOOL) fetchBookList:(int) numOfBooks
                    to:(NSMutableArray**) arrayOfBooks {
    return [BRDLeanCloudBookLister fetchBookList:numOfBooks withBookSetId:nil to:arrayOfBooks];
 }

- (BOOL) fetchBookList:(int) numOfBooks  {
    NSMutableArray* arrayOfBooks;
    if( [BRDLeanCloudBookLister fetchBookList:numOfBooks to:&arrayOfBooks]) {
        return YES;
    } else {
        return NO;
    }
}


@end
