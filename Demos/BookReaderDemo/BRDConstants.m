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

int const kFileTypeImage = 1;
int const kFileTypeAudio = 2;
int const kFileTypeTrans = 3;

NSString* const kBookImageTableTypeColumn = @"type";
NSString* const kBookImageTablePageNumberColumn = @"pageNumber";
NSString* const kBookImageTableContentColumn = @"pageContent";
NSString* const kBookImageTableBookIdColumn = @"bookName";

int const kNumPagesFirstDownload = 2;
int const kNumPagesNonFirstDownload = 2;
