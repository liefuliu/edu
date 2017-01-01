//
//  TSTBookVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/28/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "TSTBookVC.h"
#import "BRDListedBook.h"
#import <QuartzCore/QuartzCore.h>
#import "BRDColor.h"
#import "BRDBackendFactory.h"
#import "BRDBookShuff.h"
#import "BookPlayerScrollVC.h"

@interface TSTBookVC () {
    __block BOOL _isCancelled;
}

@property BRDListedBook* bookInfo;
@property NSData* bookImageData;
@property int downloadStatus;
//@property bool _isCancelled;

@end

@implementation TSTBookVC


-(id) initWithBookInfo: (BRDListedBook*) bookInfo
           bookImage: (NSData*) bookImageData {
    self = [super init];
    if (self) {
        self.bookInfo = bookInfo;
        self.bookImageData = bookImageData;
        _isCancelled = false;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"绘本详情";
    self.bookTitleLabel.text = self.bookInfo.bookName;
    self.bookNotesTextView.text = self.bookInfo.bookNotes;
    self.bookImageView.image = [UIImage imageWithData:self.bookImageData];
    
    
    [self.bookImageView.layer setShadowOpacity:0.8];
    [self.bookImageView.layer setShadowRadius:3.0];
    [self.bookImageView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [self.downloadButton setTitleColor:[BRDColor greenColor] forState:UIControlStateNormal];
    self.downloadButton.layer.borderWidth = 1.0f;
    self.downloadButton.layer.borderColor = [[BRDColor greenColor] CGColor];
    self.downloadButton.layer.cornerRadius = 10;
    
    [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [self.removeButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.openButton setTitle:@"打开" forState:UIControlStateNormal];
    
    [self drawButton:self.downloadButton];
    [self drawButton:self.removeButton];
    [self drawGreenButton:self.openButton];
    
    [self initializeConstraints];
    
    if ([[BRDBookShuff sharedObject] doesBookExist:[self.bookInfo bookId]]) {
        [self changeDownloadStatus:2];
    } else {
        [self changeDownloadStatus:0];
    }
    [self.downloadProgressView setProgress:0.0];
    
    [self.downloadProgressView setProgressTintColor:[BRDColor greenColor]];
    
    //self.deletingLabel.text = @"正在删除...";
    [self.removingProgressView setProgressTintColor:[BRDColor greenColor]];
    
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



- (void) initializeConstraints {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int height = screenRect.size.height;
    int width = screenRect.size.width;
    int imageViewWidth = width / 3;
    int imageViewHeight = height / 4;
    
    int buttonWidth = width / 4;
    int buttonSpace = width - imageViewWidth - 10 - buttonWidth * 2;
    int topOffset = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + 5;
    
    NSDictionary *nameMap = @{@"imageView": self.bookImageView,
                              @"bookSetNameLabel": self.bookTitleLabel,
                              @"bookNotesTextView":self.bookNotesTextView,
                              @"downloadButton": self.downloadButton,
                              @"removeButton": self.removeButton,
                              @"openButton": self.openButton,
                              @"cancelButton": self.cancelButton,
                              @"downloadProgressView": self.downloadProgressView,
                              @"bookDetailLabel": self.bookSampleLabel,
                              @"downloadingLabel": self.downloadingLabel,
                              @"deletingLabel": self.deletingLabel,
                              @"removingProgressView": self.removingProgressView};
    
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
    
    NSArray *horizontalConstraints2e =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"H:|-[imageView(%d)]-10-[deletingLabel]", imageViewWidth]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *horizontalConstraints2f =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"H:|-[imageView(%d)]-10-[removingProgressView(%d)]", imageViewWidth, width * 2 / 5]
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
     [NSString stringWithFormat:@"V:|-%d-[imageView(%d)]-20-[bookDetailLabel]-5-[bookNotesTextView]-50-|", topOffset, imageViewHeight]
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
     [NSString stringWithFormat:@"V:|-%d-[bookSetNameLabel]", topOffset]
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
    
    
    NSArray *verticalConstraints4e =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[deletingLabel]-[removingProgressView]-20-[bookDetailLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    
    [self.view removeConstraints:[self.view constraints]];
    
    [self.view addConstraints:horizontalConstraints1];
    [self.view addConstraints:horizontalConstraints2a];
    [self.view addConstraints:horizontalConstraints2b];
    [self.view addConstraints:horizontalConstraints2c];
    [self.view addConstraints:horizontalConstraints2d];
    [self.view addConstraints:horizontalConstraints2e];
    [self.view addConstraints:horizontalConstraints2f];
    
    [self.view addConstraints:horizontalConstraints3];
    [self.view addConstraints:horizontalConstraints5];
    [self.view addConstraints:verticalConstraints1];
    [self.view addConstraints:verticalConstraints2];
    [self.view addConstraints:verticalConstraints3];
    
    [self.view addConstraints:verticalConstraints4a];
    [self.view addConstraints:verticalConstraints4b];
    [self.view addConstraints:verticalConstraints4c];
    [self.view addConstraints:verticalConstraints4d];
    [self.view addConstraints:verticalConstraints4e];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)downloadButtonClicked:(id)sender {
    [self changeDownloadStatus:1];
    [self downloadBooks];
    
}
- (IBAction)removeButtonClicked:(id)sender {
    [[BRDBookShuff sharedObject] deleteBook:self.bookInfo.bookId];
    
    [self changeDownloadStatus:3];
}
- (IBAction)cancelButtonClicked:(id)sender {
    _isCancelled = YES;
    [self changeDownloadStatus:0];
}

- (IBAction)openButtonClicked:(id)sender {
    BookPlayerScrollVC *detailViewController = [[BookPlayerScrollVC alloc] initWithBookKey:self.bookInfo.bookId];
    [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
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
            
            self.deletingLabel.hidden = YES;
            self.removingProgressView.hidden = YES;
            break;
        case 1:
            self.downloadButton.hidden = YES;
            self.openButton.hidden = YES;
            self.removeButton.hidden = YES;
            self.downloadingLabel.hidden = NO;
            self.downloadProgressView.hidden = NO;
            self.cancelButton.hidden = NO;
            
            self.deletingLabel.hidden = YES;
            self.removingProgressView.hidden = YES;
            
            break;
        case 2:
            self.downloadButton.hidden = YES;
            self.openButton.hidden = NO;
            self.removeButton.hidden = NO;
            self.downloadingLabel.hidden = YES;
            self.downloadProgressView.hidden = YES;
            self.cancelButton.hidden = YES;
            self.deletingLabel.hidden = YES;
            self.removingProgressView.hidden = YES;
            break;
        case 3:
            self.downloadButton.hidden = YES;
            self.openButton.hidden = YES;
            self.removeButton.hidden = YES;
            self.downloadingLabel.hidden = YES;
            self.downloadProgressView.hidden = YES;
            self.cancelButton.hidden = YES;
            self.deletingLabel.hidden = NO;
            self.removingProgressView.hidden = NO;
            break;
    }
    
    [self.view setNeedsDisplay];
    if (downloadedStatus == 3) {
        //[NSThread sleepForTimeInterval:100];
        [self changeDownloadStatus:0];
    }
}



- (void) downloadBooks {
    [[BRDBackendFactory getBookDownloader] downloadBook:self.bookInfo.bookId forTopNPages:(INT_MAX / 2) cancelToken:&_isCancelled withProgressBlock:^(BOOL finished, NSError* error, float percent) {
        if (error != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"该书本不存在" delegate:self cancelButtonTitle:@"好的，知道了" otherButtonTitles:nil];
            [alert show];
        } else if (finished) {
            [self updateStatus:1.0];
            [self downloadComplete];
        } else {
            [self updateStatus:percent];
        }
    }];
}

- (void) updateStatus:(int) percent {
    /*
    if (percent < 100) {
        while (m_testView.percent < percent) {
            m_testView.percent++;
            // m_testView.percent = percent;
            if (m_testView.percent % 5 == 0) {
                [m_testView setNeedsDisplay];
            }
        }
    } else {
        [m_testView setHidden:YES];
    }*/
    
    [self.downloadProgressView setProgress:percent * 1.0 / 100.0f];
    [self.downloadProgressView setNeedsDisplay];
}

- (void) downloadComplete {
    NSString* bookKey = [self.bookInfo bookId];
    if (![[BRDBookShuff sharedObject] doesBookExist:[self.bookInfo bookId]]) {
        LocalBook* localBook = [[LocalBook alloc]
                                initBook:self.bookInfo.bookName
                                author:self.bookInfo.author
                                totalPages:self.bookInfo.totalPages
                                downloadedPages:self.bookInfo.totalPages
                                filePrefix:self.bookInfo.bookId
                                hasTranslatedText:YES
                                imageFileType:self.bookInfo.imageFileType];
        [[BRDBookShuff sharedObject] addBook:localBook forKey:bookKey];
    }
    
    [self changeDownloadStatus:2];
}


/*
- (void)decrementSpin
{
    // If we can decrement our percentage, do so, and redraw the view
    if (m_testView.percent > 0) {
        m_testView.percent = m_testView.percent - 1;
        [m_testView setNeedsDisplay];
    }
    else {
        [m_timer invalidate];
        m_timer = nil;
        [m_testView setHidden:YES];
    }
}*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
