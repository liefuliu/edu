//
//  SRXSingleTextInputVC.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 12/13/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SRXSingleTextInputVC

// Delegate 函数，在确定按钮 'buttonOk' 点击以后出发
// 参数 textInput - 输入框中的文本
// 参数 delegateId - 在initWithTitle函数中由调用者传入，用于区分不同的delegate.
- (void) textInputDone: (NSString*) textInput
      withDelegateId: (int) delegateId;
@end

@interface SRXSingleTextInputVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldInput;
@property (weak, nonatomic) IBOutlet UIButton *buttonOk;


- (id) initWithTitle:(NSString*) title
      withDelegateId: (int) delegateId;

@end
