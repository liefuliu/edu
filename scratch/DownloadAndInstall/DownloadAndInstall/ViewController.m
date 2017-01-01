//
//  ViewController.m
//  DownloadAndInstall
//
//  Created by Liefu Liu on 12/28/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

// 0: not downloaded
// 1: downloading
// 2: downloaded
@property int downloadStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.title = @"绘本详情";
    self.bookTitleLabel.text = @"绘本名称";
    self.bookNotesTextView.text = @"Danny's going to camp––and he's taking the dinosaur! First introduced in 1958 with Danny and the Dinosaur and the recent stars of Happy Birthday, Danny and the Dinosaur, this popular pair is together again in an adventure sure to please beginning readers and happy campers alike. Children's Choices for 1997 (IRA/CBC)";
    [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [self.removeButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.openButton setTitle:@"打开" forState:UIControlStateNormal];
    
    [self drawButton:self.downloadButton];
    [self drawButton:self.removeButton];
    [self drawGreenButton:self.openButton];
    
    [self initializeConstraints];
    
    
    [self changeDownloadStatus:0];
    
    [self.downloadProgressView setProgressTintColor:[UIColor greenColor]];
    

}

- (void) initializeConstraints {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int height = screenRect.size.height;
    int width = screenRect.size.width;
    int imageViewWidth = width / 3;
    int imageViewHeight = height / 4;
    
    int buttonWidth = width / 4;
    int buttonSpace = width - imageViewWidth - 10 - buttonWidth * 2;
    
    NSDictionary *nameMap = @{@"imageView": self.bookImageView,
                              @"bookSetNameLabel": self.bookTitleLabel,
                              @"bookNotesTextView":self.bookNotesTextView,
                              @"downloadButton": self.downloadButton,
                              @"removeButton": self.removeButton,
                              @"openButton": self.openButton,
                              @"cancelButton": self.cancelButton,
                              @"downloadProgressView": self.downloadProgressView,
                              @"bookDetailLabel": self.bookSampleLabel,
                              @"downloadingLabel": self.downloadingLabel};
    
    NSArray *horizontalConstraints1 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"H:|-[imageView(%d)]-15-[bookSetNameLabel]-|", imageViewWidth]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints2a =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"H:|-[imageView(%d)]-10-[downloadButton(%d)]", imageViewWidth, buttonWidth]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *horizontalConstraints2b =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"H:|-[imageView(%d)]-10-[removeButton(%d)]-[openButton(%d)]",imageViewWidth, buttonWidth, buttonWidth]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    
    
    NSArray *horizontalConstraints2c =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"H:|-[imageView(%d)]-10-[downloadProgressView(%d)]-[cancelButton]", imageViewWidth, width * 2 / 5]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints2d =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"H:|-[imageView(%d)]-10-[downloadingLabel]", imageViewWidth]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *horizontalConstraints3 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     @"H:|-[bookNotesTextView]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *horizontalConstraints5 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     @"H:|-[bookDetailLabel(150)]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *verticalConstraints1 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"V:|-80-[imageView(%d)]-20-[bookDetailLabel]-5-[bookNotesTextView]-50-|", imageViewHeight]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *verticalConstraints2 =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[downloadButton]-20-[bookDetailLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *verticalConstraints3 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     @"V:|-80-[bookSetNameLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *verticalConstraints4a =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[downloadingLabel]-[downloadProgressView]-20-[bookDetailLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *verticalConstraints4b =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton]-10-[bookDetailLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *verticalConstraints4c =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[removeButton]-20-[bookDetailLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *verticalConstraints4d =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[openButton]-20-[bookDetailLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    
    
    [self.view removeConstraints:[self.view constraints]];
    
    [self.view addConstraints:horizontalConstraints1];
    [self.view addConstraints:horizontalConstraints2a];
    [self.view addConstraints:horizontalConstraints2b];
    [self.view addConstraints:horizontalConstraints2c];
    
    [self.view addConstraints:horizontalConstraints2d];
    [self.view addConstraints:horizontalConstraints3];
    [self.view addConstraints:horizontalConstraints5];
    [self.view addConstraints:verticalConstraints1];
    [self.view addConstraints:verticalConstraints2];
    [self.view addConstraints:verticalConstraints3];
    
    [self.view addConstraints:verticalConstraints4a];
    [self.view addConstraints:verticalConstraints4b];
    
    
    [self.view addConstraints:verticalConstraints4c];
    [self.view addConstraints:verticalConstraints4d];

}

- (void) changeDownloadStatus: (int) downloadedStatus {
    self.downloadStatus = downloadedStatus;
    switch(self.downloadStatus) {
        case 0:
            self.downloadButton.hidden = NO;
            self.openButton.hidden = YES;
            self.removeButton.hidden = YES;
            
            self.downloadingLabel.hidden = YES;
            self.downloadProgressView.hidden = YES;
            self.cancelButton.hidden = YES;
            break;
        case 1:
            self.downloadButton.hidden = YES;
            self.openButton.hidden = YES;
            self.removeButton.hidden = YES;
            self.downloadingLabel.hidden = NO;
            self.downloadProgressView.hidden = NO;
            self.cancelButton.hidden = NO;

            break;
        case 2:
            self.downloadButton.hidden = YES;
            self.openButton.hidden = NO;
            self.removeButton.hidden = NO;
            self.downloadingLabel.hidden = YES;
            self.downloadProgressView.hidden = YES;
            self.cancelButton.hidden = YES;
            break;
    }
    [self.view setNeedsDisplay];
}

- (void) drawButton: (UIButton*) button {
    UIColor* greenColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
    [button setTitleColor:greenColor forState:UIControlStateNormal];
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [greenColor CGColor];
    button.layer.cornerRadius = 10;
}

- (void) drawGreenButton:(UIButton*) button {
    UIColor* greenColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
    [button setBackgroundColor:greenColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [greenColor CGColor];
    button.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)downloadButtonClicked:(id)sender {
    [self changeDownloadStatus:1];
    
}
- (IBAction)removeButtonClicked:(id)sender {
    [self changeDownloadStatus:0];
}
- (IBAction)cancelButtonClicked:(id)sender {
    [self changeDownloadStatus:2];
}

/*
- (void) startDownload {
    [self downloadBookWithProgressBlock:^(BOOL finished, NSError* error, float percent) {
        if (error != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"书本下载失败" delegate:self cancelButtonTitle:@"好的，知道了" otherButtonTitles:nil];
            [alert show];
            [self changeDownloadStatus:0];
        } else if (finished) {
            [self changeDownloadStatus:2];
            // TODO: adding the book to local store.
        } else {
            [self updateDownloadStatus:percent];
        }

    }];
}

- (void) updateDownloadStatus:(int) percent {
    
    
}

- (void) downloadBookWithProgressBlock: (void (^)(BOOL finished, NSError* error, float percent)) block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        
    });
}
*/
                   


@end
