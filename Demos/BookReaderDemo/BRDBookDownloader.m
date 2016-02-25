

#import "BRDBookDownloader.h"

#import "BRDPageDownloadOperation.h"
#import "BRDPathUtil.h"
#import "BRDConstants.h"

#import <Parse/Parse.h>

@interface BRDBookDownloader ()
@property NSOperationQueue *queue;
@end

@implementation BRDBookDownloader

+ (id)sharedObject {
    static BRDBookDownloader *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[self alloc] init];
    });
    return object;
}

- (id) init {
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)downloadBook: (NSString*) bookId
         toDirectory:(NSString*) directoryPath
           startPage: (int) startPage
        endPage:(int) endPage
   withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        PFQuery *query = [PFQuery queryWithClassName:@"BookImage"];
        query.limit = 500;
        
        // 可以考虑在此查看该书是否已经下载，根据_boo
        [query whereKey:@"bookName" equalTo:bookId];
        
        NSArray* objectsInQuery = [query findObjects];
        if (objectsInQuery.count == 0) {
            dispatch_async(dispatch_get_main_queue(),^ {
                block(YES, nil, 0);
            });
            return;
        }
        
        NSLog(@"Successfully retrieved %lu scores.", objectsInQuery.count);
        
        if (objectsInQuery != nil) {
            NSMutableArray* objectsToDownload = [[NSMutableArray alloc] init];
            for (PFObject *object in objectsInQuery) {
                if (![BRDBookDownloader isPage:object inRangeStartWith: startPage
                               endBy: endPage]) {
                    continue;
                }
                [objectsToDownload addObject:object];
            }
            
            int totalBooks = MIN(1000, (int)[objectsToDownload count]);
            int downloaded = 0;
            for (PFObject *object in objectsToDownload) {
                
                PFFile* pageContent = (PFFile*) object[@"pageContent"];
                NSLog(@"Start downloading page page: %@", [pageContent name]);
                
                // TODO(liefuliu): check if the file name is valid.
                NSString* documentPath = [BRDPathUtil convertToDocumentPath:(NSString*)[pageContent name]];
                
                // TODO(liefuliu): Check file downloading is succeeded or not.
                [BRDBookDownloader downloadParseFile:pageContent to:documentPath];
                
                ++downloaded;
                __block int percent = downloaded * 100 / totalBooks;
                
                //we get the main thread because drawing must be done in the main thread always
                dispatch_async(dispatch_get_main_queue(),^ {
                    block(NO, nil, percent);
                });
                
                if (downloaded == totalBooks) {
                    dispatch_async(dispatch_get_main_queue(),^ {
                        block(YES, nil, percent);
                    });
                    break;
                }
            }
        }
      });
         
        
}

- (void)downloadBook: (NSString*) bookId
           startPage: (int) startPage
             endPage:(int) endPage
   withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block{
    [self downloadBook:bookId
           toDirectory:[BRDPathUtil applicationDocumentsDirectoryPath]
             startPage:startPage
               endPage:endPage withProgressBlock:block];
}

- (void) downloadBook: (NSString*) bookId
         forTopNPages:(int) topNPages
    withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block {
    [self downloadBook:bookId
           toDirectory:[BRDPathUtil applicationDocumentsDirectoryPath]
          forTopNPages:topNPages
     withProgressBlock:block];
}

- (void) downloadBook:(NSString*) bookId
          toDirectory:(NSString*) directoryPath
         forTopNPages:(int) topNPages
    withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block {
    [self downloadBook:bookId toDirectory:directoryPath startPage:1 endPage:topNPages+1
     withProgressBlock:block];
}

+ (BOOL) isPage: (PFObject*) object
         inRangeStartWith: (int) startPage
          endBy: (int) endPage {
    NSString* typeString = (NSString*)object[kBookImageTableTypeColumn];
    NSString* pageNumberString = (NSString*)object[kBookImageTablePageNumberColumn];
    
    if ([typeString intValue] == kFileTypeTrans ||
        [typeString intValue] == kFileTypeCover) {
        return YES;
    }
    
    return ([pageNumberString intValue] >= startPage && [pageNumberString intValue] < endPage);
}


+ (void) downloadParseFile:(PFFile*) parseFile
                        to:(NSString*) documentPath {
    NSData* webData = [parseFile getData];
    [webData writeToFile:documentPath atomically:YES];
}

/* DO NOT SUBMIT
 - (void) downloadParseFile:(PFFile*) parseFile
 to:(NSString*) documentPath {
 NSData* webData = [parseFile getData];
 [webData writeToFile:documentPath atomically:YES];
 }
 */

@end
