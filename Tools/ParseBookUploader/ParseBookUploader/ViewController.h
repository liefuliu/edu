//
//  ViewController.h
//  ParseBookUploader
//
//  Created by Liefu Liu on 1/17/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSTextField *textFieldFileName;

@property (unsafe_unretained) IBOutlet NSTextView *textViewFileToUpload;
@property (weak) IBOutlet NSTextField *textFieldDbLink;
@property (weak) IBOutlet NSTextField *labelForTextView;

@end

