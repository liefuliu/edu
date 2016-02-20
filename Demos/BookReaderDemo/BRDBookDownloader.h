
#import <Foundation/Foundation.h>

@protocol BRDBookDownloaderDelegate

- (void) pageDownloaded: (NSString*) downloadedFile;

@end


@interface BRDBookDownloader : NSObject<BRDBookDownloaderDelegate>


+ (id) sharedObject;


- (void) downloadBook:(NSString*) bookId
           startPage:(int) startPage
             endPage:(int) endPage
   withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block;

- (void) downloadBook:(NSString*) bookId
         toDirectory:(NSString*) directoryPath
           startPage: (int) startPage
             endPage:(int) endPage
   withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block;

- (void) downloadBook: (NSString*) bookId
         forTopNPages:(int) topNPages
    withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block;

- (void) downloadBook:(NSString*) bookId
          toDirectory:(NSString*) directoryPath
         forTopNPages:(int) topNPages
    withProgressBlock:(void (^)(BOOL finished, NSError* error, float percent)) block;

- (void) pageDownloaded: (NSString*) downloadedFile;

@end
