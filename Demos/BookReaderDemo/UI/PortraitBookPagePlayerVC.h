//
//  BookPlayerVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookPagePlayerBaseVC.h"

@interface PortraitBookPagePlayerVC : BookPagePlayerBaseVC
@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;
@property (weak, nonatomic) IBOutlet UITextView *translatedTextView;


- (void) showPageAtIndex:(int) pageIndex;

@end
