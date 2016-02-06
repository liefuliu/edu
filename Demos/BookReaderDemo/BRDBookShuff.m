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

@interface BRDBookShuff()
@property NSMutableDictionary* bookCache;
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

- (id)init {
    if (self = [super init]) {
        _bookCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (BOOL) doesBookExist: (NSString*) bookKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* bookDictionary = [defaults objectForKey:kDownloadedBookKeyString];
    
    return ([bookDictionary objectForKey:bookKey] != nil);
}

- (void) addBook: (NSString*) bookkey {
    if ([self doesBookExist:bookkey]) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* bookDictionary = (NSDictionary*)[defaults objectForKey:kDownloadedBookKeyString];
    NSMutableDictionary* newBookDictionary = [[NSMutableDictionary alloc] initWithDictionary:bookDictionary];

    NSString const* dummy_string = @"dummy_string";
    [newBookDictionary setValue:dummy_string forKey:bookkey];
    [defaults setObject:newBookDictionary forKey:kDownloadedBookKeyString];
}


- (LocalBook*) getBook: (NSString*) bookKey {
    if ([_bookCache objectForKey:bookKey] != nil) {
        return (LocalBook*) [_bookCache objectForKey:bookKey];
    }
    int totalPageNum = [self countTotalPagesForBook:bookKey];
    NSString* filePrefix = [self getBookPrefix:bookKey];
    
    LocalBook* newBook = [[LocalBook alloc] initBook:bookKey
                                              author:nil
                                          totalPages:totalPageNum
                                          filePrefix:filePrefix
                                   hasTranslatedText:YES];
    [_bookCache setValue:newBook forKey:bookKey];
    return newBook;
    
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


@end
