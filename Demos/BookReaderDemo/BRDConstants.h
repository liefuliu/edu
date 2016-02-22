//
//  BRDConstants.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/3/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kNSDefaultsFirstLaunch;
extern NSString* const kNSDefaultsFirstPageLoad;
extern NSString* const kDownloadedBookKeyString;

extern int const kFileTypeImage;
extern int const kFileTypeAudio;
extern int const kFileTypeTrans;


extern NSString* const kBookImageTableTypeColumn;
extern NSString* const kBookImageTablePageNumberColumn;
extern NSString* const kBookImageTableContentColumn;
extern NSString* const kBookImageTableBookIdColumn;

extern int const kNumPagesFirstDownload;
extern int const kNumPagesNonFirstDownload;

extern BOOL const kDelayDownloadTillEndofPreview;