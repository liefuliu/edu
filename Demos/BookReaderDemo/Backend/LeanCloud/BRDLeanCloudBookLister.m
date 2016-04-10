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
#import <AVOSCloud/AVOSCloud.h>

@interface BRDLeanCloudBookLister()

@property NSArray* currentBookList;

@end

// TODO(liefuliu): move to BRDConstants.h
static const int MAX_BOOK_LIST = 1000;

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


- (BOOL) fetchBookList:(int) numOfBooks  {
    AVQuery *query = [AVQuery queryWithClassName:@"Book"];
    [query whereKey:@"isActive" equalTo:[NSNumber numberWithBool:YES]];
    
    /*
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSMutableArray* bookList = [[NSMutableArray alloc] init];
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                [bookList addObject:(NSString*)object[@"bookName"]];
            }
            self.currentBookList = bookList;
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];*/
    
    NSArray* objects = [query findObjects];
    NSLog(@"Successfully retrieved %d scores.", objects.count);
    
    if (objects != nil) {
        NSMutableArray* bookList = [[NSMutableArray alloc] init];
        for (AVObject *object in objects) {
            NSString* bookId = (NSString*) object[@"bookId"];
            if (bookId != nil) {
                NSString* bookName = (NSString*) object[@"bookName"];
                NSString* author = (NSString*) object[@"author"];
                int totalPages = [((NSString*)object[@"totalPages"]) intValue];
                
                BRDListedBook* serverBook = [[BRDListedBook alloc]
                                      initBook: bookId
                                          name: bookName
                                      author:author
                                      totalPages:totalPages
                                      cover:nil];
            
                [bookList addObject:serverBook];
            }
        }
        self.currentBookList = bookList;
        return YES;
    } else {
        return NO;
    }
}


@end