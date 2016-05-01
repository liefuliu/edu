//
//  BRDConstants.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/3/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDConstants.h"

NSString* const kNSDefaultsFirstLaunch = @"first_launch";
NSString* const kNSDefaultsFirstPageLoad = @"first_page_load";
NSString* const kDownloadedBookKeyString = @"downloaded_book_key_v2";
NSString* const kBookStatusKeyString = @"book_status_key";
NSString* const kCachedBooksKey = @"book_cache_key";

int const kFileTypeImage = 1;
int const kFileTypeAudio = 2;
int const kFileTypeTrans = 3;
int const kFileTypeCover = 4;

int const kImageFileFormatUnknown = 0;
int const kImageFileFormatJpg = 1;
int const kImageFileFormatPdf = 2;

NSString* const kBookImageTableTypeColumn = @"type";
NSString* const kBookImageTablePageNumberColumn = @"pageNumber";
NSString* const kBookImageTableContentColumn = @"pageContent";
NSString* const kBookImageTableBookIdColumn = @"bookName";

int const kNumPagesFirstDownload = 6;
int const kNumPagesNonFirstDownload = 4;

BOOL const kDelayDownloadTillEndofPreview = NO;

float const kTimeoutBookFirstLoad = 5.0;

int const kBackendParse = 1;
int const kBackendLeanCloud = 2;

