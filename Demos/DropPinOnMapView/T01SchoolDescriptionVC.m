//
//  T01SchoolDescriptionVC.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 11/14/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "T01SchoolDescriptionVC.h"
#import "UIViewController+Charleene.h"

@interface T01SchoolDescriptionVC ()

@property NSString* descriptiveText;

@end

@implementation T01SchoolDescriptionVC

static const int kMinDescriptionLength = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.descriptionTextField.layer.borderWidth = 1.0f;
    self.descriptionTextField.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = NSLocalizedString(@"Input school description", nil);
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(doneButtonClicked:)];
    bbi.enabled = NO;
    navItem.rightBarButtonItem = bbi;
    
    self.descriptionTextField.delegate = self;
    if (_descriptiveText) {
        self.descriptionTextField.text = _descriptiveText;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setDescriptionText: (NSString*) text {
    _descriptiveText = text;
}

- (IBAction)doneButtonClicked:(id)sender {
    if (self.descriptionTextField.text.length < kMinDescriptionLength) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Description length must be no less than 10 characters", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(descriptionEntered:)]) {
        [self.delegate descriptionEntered:self.descriptionTextField.text];
    }
    
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)okButtonTouched:(id)sender {
    if (self.descriptionTextField.text.length < kMinDescriptionLength) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Description length must be no less than 10 characters", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(descriptionEntered:)]) {
        [self.delegate descriptionEntered:self.descriptionTextField.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
