//
//  BookHandler.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/22/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDBookLister.h"
#import "BRDBookSummary.h"

#import "ServerBook.h"
#import <Parse/Parse.h>

@interface BRDBookLister()

@property NSArray* currentBookList;

@end

static const int MAX_BOOK_LIST = 1000;
static const int kTypeImage = 1;
static const int kTypeAudio = 2;
static const int kTypeTranslation = 3;

@implementation BRDBookLister

- (id) init {
    return [super init];
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
        
    [[[query whereKey:@"bookName" containedIn:arrayOfBooks]
         whereKey:@"pageNumber" equalTo:@"1"]
     whereKey:@"type" equalTo:@(kTypeImage).stringValue];
    
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
                int totalPages = -1;
                NSData* coverImageData;
            
                ServerBook* serverBook = [[ServerBook alloc]
                                      initBook: bookId
                                          name: bookName
                                      author:author
                                      totalPages:totalPages
                                      cover:coverImageData];
            
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