

#import "BRDBookDownloader.h"
#import "BRDPathUtil.h"
#import <Parse/Parse.h>

@implementation BRDBookDownloader

+ (id)sharedObject {
    static BRDBookDownloader *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[self alloc] init];
    });
    return object;
}

- (void) downloadBook: (NSString*) bookId {
    [self downloadBook:bookId
     toDirectory:[BRDPathUtil applicationDocumentsDirectoryPath]
     withMaxLimit:INT_MAX];
}

// test only
- (void) downloadBook:(NSString*) bookId
          toDirectory:(NSString*) directoryPath
         withMaxLimit:(int) maxLimit {
    PFQuery *query = [PFQuery queryWithClassName:@"BookImage"];
    query.limit = maxLimit;
    [[query whereKey:@"bookName" equalTo:bookId] orderByAscending:@"pageNumber"];
    
    NSArray* objects = [query findObjects];
    if (objects.count == 0) {
        return;
    }
    
    NSLog(@"Successfully retrieved %lu scores.", objects.count);
    
    if (objects != nil) {
        int downloaded = 0;
        for (PFObject *object in objects) {
            PFFile* pageContent = (PFFile*) object[@"pageContent"];
            NSLog(@"bookName: %@", [pageContent name]);
            
            NSString* documentPath = [directoryPath stringByAppendingPathComponent: [pageContent name]];
            
            [self downloadParseFile:pageContent to:documentPath];
            NSLog(@"Book has been downloaded to local path: %@", documentPath);
            
            ++downloaded;
        }
    }
}

- (void) downloadParseFile:(PFFile*) parseFile
                        to:(NSString*) documentPath {
    NSData* webData = [parseFile getData];
    [webData writeToFile:documentPath atomically:YES];
}


@end
