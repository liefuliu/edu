
#import <Foundation/Foundation.h>

@interface BRDBookDownloader : NSObject


+ (id) sharedObject;

- (void) downloadBook: (NSString*) bookId;

- (void) downloadBook:(NSString*) bookId
          toDirectory:(NSString*) directoryPath
         withMaxLimit:(int) maxLimit;

@end
