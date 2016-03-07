//
//  BookHandler.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/22/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDParseBookLister.h"
#import "BRDBookSummary.h"
#import "BRDConstants.h"
#import "BRDListedBook.h"
#import <Parse/Parse.h>

@interface BRDParseBookLister()

@property NSArray* currentBookList;

@end

// TODO(liefuliu): move to BRDConstants.h
static const int MAX_BOOK_LIST = 1000;

@implementation BRDParseBookLister

+ (id)sharedObject {
    static BRDParseBookLister *object = nil;
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
    
    if (self.currentBookList == nil) {
        if (![self fetchBookList:MAX_BOOK_LIST]) {
            return NO;
        }
    }
    
    *arrayOfBooks = [[NSMutableArray alloc] init];
    for (int i = pageOffset; i < MIN(numOfBooks + pageOffset, [self.currentBookList count]); i++) {
        [(NSMutableArray*)*arrayOfBooks addObject:self.currentBookList[i]];
    }
    
    return YES;
    
}

- (BOOL) getSummaryInfoForBooks: (NSArray*) arrayOfBooks
                             to: (NSDictionary**) summaryInfo {
        PFQuery *query = [PFQuery queryWithClassName:@"BookImage"];
        
    [[query whereKey:@"bookName" containedIn:arrayOfBooks]
     whereKey:@"type" equalTo:@(kFileTypeCover).stringValue];
    
    NSArray* objects = [query findObjects];
    
    *summaryInfo = [[NSMutableDictionary alloc] init];
    
        if (objects != nil) {
            for (PFObject *object in objects) {
                PFFile* pageContent = (PFFile*) object[@"pageContent"];
                NSData* imgData = [pageContent getData];
                
                BRDBookSummary* summary = [[BRDBookSummary alloc] init];
                summary.imageData = imgData;
                [*summaryInfo setValue:summary forKey:(NSString*)object[@"bookName"]];
            }
        }
    
    return YES;
}


- (BOOL) fetchBookList:(int) numOfBooks  {
    PFQuery *query = [PFQuery queryWithClassName:@"Book"];
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
        for (PFObject *object in objects) {
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
