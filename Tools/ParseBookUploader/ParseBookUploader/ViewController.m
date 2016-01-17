//
//  ViewController.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 1/17/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)buttonClicked:(id)sender {
    NSLog(@"button clicked");
    [self EnumerateDir];
}

- (void) EnumerateDir {
    NSURL *url = [NSURL URLWithString:@"file:///Users/liefuliu/src/edu/Demos/BookReaderDemo/Books/"];
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
                           NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtURL:url
                      includingPropertiesForKeys:properties
                      options:(NSDirectoryEnumerationSkipsHiddenFiles)
                      error:&error];
    if (array != nil) {
        // Handle the error
        for (NSString* file in array) {
            NSLog(@"file path: %@", file);
        }
    }

}

@end
