//
//  BookPreviewViewController.h
//  ParseBookUploader
//
//  Created by Liefu Liu on 7/10/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface BookPreviewViewController : NSViewController
@property (weak) IBOutlet NSImageCell *pageImageView;

-(BOOL) loadBookFiles: (NSArray*) bookFileNames;
@property (unsafe_unretained) IBOutlet NSTextView *displayTextView;

@end
