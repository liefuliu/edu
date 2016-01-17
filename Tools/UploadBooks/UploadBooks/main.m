//
//  main.m
//  UploadBooks
//
//  Created by Liefu Liu on 1/9/16.
//  Copyright (c) 2016 SanRenXing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

void SetupParse();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        SetupParse();
        
    }
    return 0;
}

void SetupParse() {
    [Parse enableLocalDatastore];
    
    /*
    // Initialize Parse.
    [Parse setApplicationId:@"v9dWkNcnBpIqIvramHo8CqAUts18toQJ1d9MTMNH"
                  clientKey:@"mwV3UjHfcFfSohPbjYk9QKt567OyJm6701TRSQmf"];*/
    /*
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:nil];
     */
}