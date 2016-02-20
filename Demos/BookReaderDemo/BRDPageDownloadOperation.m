//
//  BRDPageDownloadOperation.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/12/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDPageDownloadOperation.h"
#import "BRDBookDownloader.h"

#import <Parse/Parse.h>

@interface BRDPageDownloadOperation()

@property PFFile* downloadSource;
@property NSString* downloadTarget;

@end

@implementation BRDPageDownloadOperation


- (id) initWithDownloadSrc:(PFFile*) downloadSource
                    target:(NSString*) downloadTarget {
    self = [super init];
    if (self) {
        _downloadSource =downloadSource;
        _downloadTarget =downloadTarget;
    }
    return self;
}

- (void)main {
    [self downloadParseFile:self.downloadSource to:self.downloadTarget];
    
    /*
    [[BRDBookDownloader sharedObject] performSelectorOnMainThread:@selector(pageDownloaded:)
                                           withObject:_downloadTarget
                                        waitUntilDone:YES];*/
    
    [self.delegate pageDownloaded:self.downloadTarget];
}


- (void) downloadParseFile:(PFFile*) parseFile
                        to:(NSString*) documentPath {
    NSData* webData = [parseFile getData];
    [webData writeToFile:documentPath atomically:YES];
}



@end
