

#import "BRDLeanCloudBookDownloader.h"

#import "BRDPathUtil.h"
#import "BRDConstants.h"

#import <AVOSCloud/AVOSCloud.h>


@interface BRDLeanCloudBookDownloader ()
@property NSOperationQueue *queue;
@end

@implementation BRDLeanCloudBookDownloader

+ (id)sharedObject {
    static BRDLeanCloudBookDownloader *object = nil;
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
        AVQuery *query = [AVQuery queryWithClassName:@"BookImage"];
        query.limit = 500;
        
        // 可以考虑在此查看该书是否已经下载，根据_boo
        [query whereKey:@"bookId" equalTo:bookId];
        
        NSArray* objectsInQuery = [query findObjects];
        if (objectsInQuery.count == 0) {
            dispatch_async(dispatch_get_main_queue(),^ {
                block(YES, nil, 0);
            });
            return;
        }
        
        if (objectsInQuery != nil) {
            NSMutableArray* objectsToDownload = [[NSMutableArray alloc] init];
            for (AVObject *object in objectsInQuery) {
                if (![BRDLeanCloudBookDownloader isPage:object inRangeStartWith: startPage
                                                  endBy: endPage]) {
                    continue;
                }
                [objectsToDownload addObject:object];
            }
            
            int totalBooks = MIN(1000, (int)[objectsToDownload count]);
            int downloaded = 0;
            
            for (AVObject *object in objectsToDownload) {
                
                AVFile* pageContent = (AVFile*) object[@"pageContent"];
                // NSLog(@"Start downloading page page: %@", [pageContent name]);
                
                // TODO(liefuliu): check if the file name is valid.
                const int MAX_DOWNLOAD_ATTEMPT = 5;
                int attempt_times = 0;
                bool downloadPageSucceeded = false;
                
                while (!downloadPageSucceeded) {
                    NSString* documentPath =
                    [directoryPath stringByAppendingPathComponent:[BRDPathUtil extractParseFileName:[pageContent name]]];
                    //[BRDPathUtil convertToDocumentPath:(NSString*)[pageContent name]];
                    
                    [BRDLeanCloudBookDownloader downloadParseFile:pageContent to:documentPath];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
                        NSLog(@"Download %@ succeeded", documentPath);
                        break;
                    }
                    
                    ++attempt_times;
                    NSLog(@"Download %@ failed. Attempt %d of %d", documentPath, attempt_times, MAX_DOWNLOAD_ATTEMPT);
                    if (attempt_times >= MAX_DOWNLOAD_ATTEMPT) {
                        // Ignore the error for now.
                        // TODO(liefuliu): handle the error.
                        break;
                    }
                }
                
                ++downloaded;
                __block int percent = downloaded * 100 / totalBooks;
                
                //we get the main thread because drawing must be done in the main thread always
                dispatch_async(dispatch_get_main_queue(),^ {
                    block(NO, nil, percent);
                });
                
                // Investigate why totalBooks is 13... TODO
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

+ (BOOL) isPage: (AVObject*) object
inRangeStartWith: (int) startPage
          endBy: (int) endPage {
    NSString* typeString = (NSString*)object[kBookImageTableTypeColumn];
    NSString* pageNumberString = (NSString*)object[kBookImageTablePageNumberColumn];
    if ([typeString intValue] == kFileTypeCover && startPage <= 1) {
        return YES;
    }
    
    if ([typeString intValue] == kFileTypeTrans && startPage <= 1) {
        return YES;
    }
    
    return ([pageNumberString intValue] >= startPage && [pageNumberString intValue] < endPage);
}


+ (void) downloadParseFile:(AVFile*) parseFile
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
