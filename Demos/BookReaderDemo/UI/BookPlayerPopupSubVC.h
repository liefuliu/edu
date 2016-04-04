//
//  BookPlayerPopupSubVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 4/3/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kBookPlayerPopupSubViewExit = 0,
    kBookPlayerPopupSubViewReplay = 1,
    kBookPlayerPopupSubViewResume = 2
} BookPlayerPopupSubViewOperation;

@protocol BookPlayerPopupSubVCDelegate <NSObject>

- (void) viewDismissed:(BookPlayerPopupSubViewOperation) operationChoosed;

@end

@interface BookPlayerPopupSubVC : UIViewController

@property (nonatomic,strong) id delegate;


@end
