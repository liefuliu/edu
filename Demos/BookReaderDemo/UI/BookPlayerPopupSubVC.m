//
//  BookPlayerPopupSubVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 4/3/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BookPlayerPopupSubVC.h"

@interface BookPlayerPopupSubVC ()
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@property (weak, nonatomic) IBOutlet UIButton *replayButton;

@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

@end

@implementation BookPlayerPopupSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setRoundAngle:self.exitButton];
    [self setRoundAngle:self.replayButton];
    [self setRoundAngle:self.resumeButton];
    
    [self.exitButton setHidden:YES];
    [self.replayButton setHidden:YES];
    [self.resumeButton setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setRoundAngle:(UIButton*) button {
    button.layer.cornerRadius = 4;
    
   [button.layer setBorderWidth:1.0];
   [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onExitButtonClicked:(id)sender {
    [self.delegate viewDismissed:kBookPlayerPopupSubViewExit];
}

- (IBAction)onReplayButtonClicked:(id)sender {
    [self.delegate viewDismissed:kBookPlayerPopupSubViewReplay];
}

- (IBAction)onResumeButtonClicked:(id)sender {
    [self.delegate viewDismissed:kBookPlayerPopupSubViewResume];
    
}
@end
