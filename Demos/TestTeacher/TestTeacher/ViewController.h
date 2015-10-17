//
//  ViewController.h
//  TestTeacher
//
//  Created by Liefu Liu on 8/21/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *boyQuestionText;
@property (weak, nonatomic) IBOutlet UITextField *girlQuestionText;
@property (weak, nonatomic) IBOutlet UITextField *boyAnswerText;
@property (weak, nonatomic) IBOutlet UITextField *girlAnswerText;

@property (strong) NSString* objectId;

@end

