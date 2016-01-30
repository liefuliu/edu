//
//  BookRepositoryTVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/22/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDownloadWaitVC.h"

@interface BookRepositoryTVC : UITableViewController <BookDownloadWaitVCDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

- (void) downloadComplete: (NSString*) bookKey;

@end
