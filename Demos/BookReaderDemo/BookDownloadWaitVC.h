//
//  BookDownloadWaitVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/24/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookDownloadWaitVCDelegate <NSObject>

- (void) downloadComplete:(NSString*) bookKeyUnused forTopNPages:(int)pagesDownloaded;

@end

@interface BookDownloadWaitVC : UIViewController

@property (nonatomic,strong) id delegate;

- (id) initWithBookKey: (NSString*) bookKey;

@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;

@end
