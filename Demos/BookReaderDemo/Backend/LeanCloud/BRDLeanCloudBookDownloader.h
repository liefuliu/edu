
#import <Foundation/Foundation.h>
#import "BRDBookDownloader.h"
/*
@protocol BRDBookDownloaderDelegate

- (void) pageDownloaded: (NSString*) downloadedFile;

@end
*/

@interface BRDLeanCloudBookDownloader : NSObject<BRDBookDownloader>


+ (id) sharedObject;


- (void) downloadBook:(NSString*) bookId
           startPage:(int) startPage
             endPage:(int) endPage
cancelToken:(BOOL*) isCancelled
   withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block;

- (void) downloadBook:(NSString*) bookId
         toDirectory:(NSString*) directoryPath
           startPage: (int) startPage
             endPage:(int) endPage
cancelToken:(BOOL*) isCancelled
   withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block;

- (void) downloadBook: (NSString*) bookId
         forTopNPages:(int) topNPages
          cancelToken:(BOOL*) isCancelled
    withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block;

- (void) downloadBook:(NSString*) bookId
          toDirectory:(NSString*) directoryPath
         forTopNPages:(int) topNPages
cancelToken:(BOOL*) isCancelled
    withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block;

- (void) pageDownloaded: (NSString*) downloadedFile;

@end
