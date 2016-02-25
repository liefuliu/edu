//
//  BRDLocalStore.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/30/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDConstants.h"
#import "BRDBookShuff.h"
#import "BRDPathUtil.h"
#import "BRDBookSummary.h"

@interface BRDBookShuff()
//@property NSMutableDictionary* bookCache;
@end

@implementation BRDBookShuff

+ (id)sharedObject {
    static BRDBookShuff *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[self alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:kDownloadedBookKeyString]) {
            NSMutableDictionary* bookDictionary = [[NSMutableDictionary alloc] init];
            [defaults setObject:bookDictionary forKey:kDownloadedBookKeyString];
        }
    });
    return object;
}

- (BOOL) doesBookExist: (NSString*) bookKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* bookDictionary = [defaults objectForKey:kDownloadedBookKeyString];
    
    return ([bookDictionary objectForKey:bookKey] != nil);
}

- (void) addBook:(LocalBook*) bookInfo
          forKey:(NSString*) bookKey{
    if ([self doesBookExist:bookKey]) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* newBookDictionary = [[NSMutableDictionary alloc] initWithDictionary:[BRDBookShuff getNSUserDefaultBookDictionary]];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bookInfo];
    [newBookDictionary setValue:data forKey:bookKey];
    [defaults setObject:newBookDictionary forKey:kDownloadedBookKeyString];
}


- (LocalBook*) getBook: (NSString*) bookKey {
    NSData* data = [[BRDBookShuff getNSUserDefaultBookDictionary] objectForKey:bookKey];
    LocalBook* newBook = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return newBook;
}

- (void) updateBook:(LocalBook*) bookInfo
             forKey:(NSString*) bookKey {
    if (![self doesBookExist:bookKey]) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* newBookDictionary = [[NSMutableDictionary alloc] initWithDictionary:[BRDBookShuff getNSUserDefaultBookDictionary]];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bookInfo];
    [newBookDictionary setValue:data forKey:bookKey];
    [defaults setObject:newBookDictionary forKey:kDownloadedBookKeyString];

}

- (void) deleteBook: (NSString*) bookKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* newBookDictionary = [[NSMutableDictionary alloc] initWithDictionary:[BRDBookShuff getNSUserDefaultBookDictionary]];
    
    [newBookDictionary removeObjectForKey:bookKey];
    [defaults setObject:newBookDictionary forKey:kDownloadedBookKeyString];
}

- (NSArray*) getAllBookKeys {
    return [BRDBookShuff getNSUserDefaultBookDictionary].allKeys;
}


#pragma private functions


- (NSString*) getBookPrefix:(NSString*) bookKey {
    return [bookKey lowercaseString];
}

- (int) countTotalPagesForBook:(NSString*) bookey {
    NSString* bookPrefix = [self getBookPrefix:bookey];
    if (bookPrefix.length == 0) {
        return 0;
    }
    
    NSURL* url = [BRDPathUtil applicationDocumentsDirectory];
    
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
                           NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtURL:url
                      includingPropertiesForKeys:properties
                      options:(NSDirectoryEnumerationSkipsHiddenFiles)
                      error:&error];
    
    // 检查文件名是否匹配正则表达式。
    NSString* fileRegex = [NSString stringWithFormat:@"%@.*jpg", bookPrefix];
    NSMutableArray* arrayFilePath = [[NSMutableArray alloc] init];
    
    for (NSString* item in array) {
        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:fileRegex options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSString* theFileName = [item lastPathComponent];
        NSTextCheckingResult *match = [regex firstMatchInString:theFileName options:0 range:NSMakeRange(0, [theFileName length])];
        
        if (match) {
            [arrayFilePath addObject:item];
        }
    }
    
    return (int)[arrayFilePath count];
}

+ (BOOL) bookHasTranslation: (NSString*) bookKey {
    return YES;
}

+ (NSDictionary*) getNSUserDefaultBookDictionary {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* bookDictionary = (NSDictionary*)[defaults objectForKey:kDownloadedBookKeyString];
    return bookDictionary;
}


@end