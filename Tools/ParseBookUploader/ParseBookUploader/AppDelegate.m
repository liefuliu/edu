//
//  AppDelegate.m
//  ParseBookUploader
//
//  Created by Liefu Liu on 1/17/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>


#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // Insert code here to initialize your application
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"28Nxhuytj9iQaejhfR6oMkESwJ6OBksofut1Claa"
                  clientKey:@"t6AN1ShCy7Um2uJQnb7Ds1ZwIHnUyJ1cw1BmhzW8"];
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo10"] = @"bar10";
    [testObject saveInBackground];
    
    
    [AVOSCloud setApplicationId:@"tBAtpm2DzImtaakvzHVxEWvX-gzGzoHsz"
                      clientKey:@"GAPD7s4yhbODKljGsRNpKf7M"];
    
    
    AVObject *post = [AVObject objectWithClassName:@"TestObject"];
    [post setObject:@"Hi World!" forKey:@"words"];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 保存成功了！
        }
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
