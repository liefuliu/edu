//
//  AppDelegate.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 11/28/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceRecordViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    VoiceRecordViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet VoiceRecordViewController *viewController;


@end

