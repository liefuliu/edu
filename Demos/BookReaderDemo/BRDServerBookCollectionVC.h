//
//  BRDServerBookCollectionVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/31/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDownloadWaitVC.h"

@interface BRDServerBookCollectionVC : UICollectionViewController <BookDownloadWaitVCDelegate>

- (void) downloadComplete: (NSString*) bookKey;

@end
