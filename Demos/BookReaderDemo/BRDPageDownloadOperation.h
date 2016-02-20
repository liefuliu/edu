//
//  BRDPageDownloadOperation.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/12/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BRDBookDownloader.h"

@class PFFile;

@interface BRDPageDownloadOperation : NSOperation

- (id) initWithDownloadSrc:(PFFile*) downloadSource
                target:(NSString*) downloadTarget;

@property id<BRDBookDownloaderDelegate> delegate;

@end
