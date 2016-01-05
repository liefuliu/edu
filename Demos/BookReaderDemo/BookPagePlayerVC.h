//
//  BookPlayerVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookPagePlayerVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;
@property (weak, nonatomic) IBOutlet UITextView *translatedTextView;

@property int page;

- (id) initWithBookKey:(NSString*) localBookKey withPage:(int) pageIndex;

- (void) showPageAtIndex:(int) pageIndex;

@end
