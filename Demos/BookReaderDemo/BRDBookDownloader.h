//
//  BRDBookDownloader.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 3/6/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BRDBookDownloader

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
