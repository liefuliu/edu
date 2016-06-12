#import "BRDConstants.h"
#import "BookPlayerScrollVC.h"
#import "BookPagePlayerVC.h"
#import "BRDFileUtil.h"
#import "BRDPathUtil.h"
#import "BRDBookShuff.h"
#import "BRDBackendFactory.h"
#import "BookPlayerPopupSubVC.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import <QuartzCore/QuartzCore.h>

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface BookPlayerScrollVC ()

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property LocalBook* localBookInfo;
@property NSString* localBookKey;
@property NSArray* translatedText;
@property int currentPage;

@property (nonatomic, retain) AVAudioPlayer *player;

@property
CGFloat lastContentOffset;

// 最近一次滑动是否向右。
@property BOOL scrollToRight;

// 最近一次滑动是否向左。
@property BOOL scrollToLeft;

// 绘本时候已经关闭
@property BOOL viewIsDismissed;

// 旋转进度图标
@property UIActivityIndicatorView *spinner;

// 长按手势
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;

// 短按手势
@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;

@end

#pragma mark -

@implementation BookPlayerScrollVC

static const float kVerticalScale = 1.0;

- (id) initWithBookKey:(NSString*) localBookKey {
    if (self = [super init]) {
        self.localBookKey = localBookKey;
        self.localBookInfo = [[BRDBookShuff sharedObject] getBook:self.localBookKey];
        if ([self.localBookInfo hasTranslatedText]) {
            self.translatedText = [BRDFileUtil extractTranslatedText:self.localBookKey];
        } else {
            self.translatedText = @[];
        }
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // 设置按钮的样式。
    [self setRoundAngle:self.exitButton];
    [self setRoundAngle:self.replayButton];
    [self setRoundAngle:self.resumeButton];
    
    [self hidePopupButton:YES];

    self.buttonMenu.layer.cornerRadius = self.buttonMenu.bounds.size.height/ 15;
    [self.view bringSubviewToFront:self.buttonMenu];
    self.buttonMenu.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    self.buttonMenu.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentCenter;
    
    // 设置能够横向滚动的scroll view
    self.scrollView1.pagingEnabled = YES;
    self.scrollView1.showsHorizontalScrollIndicator = NO;
    self.scrollView1.showsVerticalScrollIndicator = NO;
    self.scrollView1.scrollsToTop = NO;
    self.scrollView1.delegate = self;
    
    // 定义操作手势
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 50.0f;
    [self.view addGestureRecognizer:self.lpgr];
    
    self.tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popupSubViewTouched:)];
    [self.view addGestureRecognizer:self.tapGesture];

    // 旋转进度图标，用于表示该页面正在载入.
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(160, 240);
    _spinner.tag = 12;
    [self.view addSubview:_spinner];
    
    // 如果App是首次运行，则在初始化页面之前，显示操作提示。否则，直接显示初始化页面。
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kNSDefaultsFirstPageLoad])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNSDefaultsFirstPageLoad];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"操作提示", nil)
                                                        message:@"向左滑动往后翻页, 向右滑动往前翻页, 长按屏幕返回主书单。"
                                                       delegate:self
                                              cancelButtonTitle:@"好的，知道了"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self initializeFromCurrentPage:YES];
    }
    
    _currentPage = 0;
    if (self.localBookInfo.downloadedPages < self.localBookInfo.totalPages) {
        [self downloadBookTillTopNPages];
    }
    
    [self updateLastReadDate];
}

#pragma 视图设置辅助函数

- (void) setRoundAngle:(UIButton*) button {
    button.layer.cornerRadius = 4;
    
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
}

#pragma 操作响应

// 响应主页面上的长按手势。
- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    // 仅在辅助面板没有弹出时，响应长按手势。
    if ([self isPopupViewHidden]) {
        if ([sender isEqual:self.lpgr]) {
            if (sender.state == UIGestureRecognizerStateBegan) {
                // 如果长按，则退出绘本。
                [self exitFromCurrentBook];
            }
        }
    }
}

// 响应辅助页面的短按手势。
- (void)popupSubViewTouched:(UITapGestureRecognizer *)sender
{
    // 仅在辅助面板弹出时，响应短按手势。
    if (![self isPopupViewHidden]) {
        if ([sender isEqual:self.tapGesture]) {
            if (sender.state == UIGestureRecognizerStateEnded) {
                [self resumePlay];
            }
        }
    }
}

// 在点击"好的，知道了“以后，初始化页面。
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self initializeFromCurrentPage:YES];
}

// 响应屏幕90度旋转的操作。
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // remove all the subviews from our scrollview
    [self initializeFromCurrentPage:NO];
}

// 响应滚动视图(scrollView1)正在滚动的事件。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.x) {
        self.scrollToLeft = true;
        self.scrollToRight = false;
    } else if (self.lastContentOffset < scrollView.contentOffset.x) {
        self.scrollToLeft = false;
        self.scrollToRight = true;
    }
    self.lastContentOffset = scrollView.contentOffset.x;
}

// 响应滚动视图(scrollView1)结束滚动的事件。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    // 当滚动结束时，我们需要用下列公式求出是滚到当前页 (currentPage)，前一页 (currentPage - 1) 还是后一页 (currentPage + 1)。
    // scrollView1.contentOffset.x 值域为 [pageWidth * (currentPage - 1）, pageWidth * currentPage + 1].
    // 当x < pageWitdh * (currentPage - 0.5)时，翻到前一页。
    // 当x > pageWidth * (currentPage + 0.5)时，翻到后一页。
    // 其余情况，驻留在当前页。
    CGFloat pageWidth = CGRectGetWidth(self.scrollView1.frame);
    NSUInteger page = floor((self.scrollView1.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (self.currentPage == page) {
        // 如果在首页向右滑动（向前翻书），则显示首页提示。
        if (page == 0 && self.scrollToRight) {
            [self alertForFirstPage];
            return;
        }
        
        // 如果在末页向左滑动 (向后翻书），则显示末页提示。
        if (page == self.localBookInfo.downloadedPages -1 && self.scrollToLeft) {
            [self alertForLastPage];
            return;
        }
    } else {
        int totalPages = self.localBookInfo.totalPages;
        int downloadedPages = self.localBookInfo.downloadedPages;
        
        self.currentPage = page;
        
        if (self.viewControllers.count == totalPages) {
            // 正常情况: 下载已经全部完成。
        } else if (self.currentPage + 1 == self.viewControllers.count ) {
            // 已经翻到所有显示绘本页的最后一页。
            if (self.viewControllers.count <= downloadedPages) {
                // 情况: 已下载的绘本页数大于显示的绘本页数，则重新初始化会所有绘本页，以显示更多的绘本页数。
                // 注意，显示的绘本页数为 (self.viewControllers.count - 1).
                [self initializeFromCurrentPage:NO];
            } else {
                // 情况: 已下载的绘本页数等于显示的绘本页数, 则等待更多页面下载。
                [_spinner startAnimating];
                if (kDelayDownloadTillEndofPreview) {
                    [self downloadBookTillTopNPages];
                }
                return;
            }
        }
        
        [self gotoPage:YES];
    }
}


#pragma 操作辅助函数

- (void) updateLastReadDate {
    BRDLocalBookStatus* localBookStatus = [[BRDBookShuff sharedObject]getBookStatus:self.localBookKey];

    localBookStatus.lastReadDate = [NSDate date];
    [[BRDBookShuff sharedObject] updateBookStatus:localBookStatus forKey:self.localBookKey];
}

// 退出绘本。
- (void) exitFromCurrentBook {
    BRDLocalBookStatus* localBookStatus = [[BRDBookShuff sharedObject]getBookStatus:self.localBookKey];
    
    // 设置阅读状态。
    // 当翻页过快时，self.currentPage有可能大于等于总下载页数页数 (self.localBookInfo.downloadedPages)，于是我们取
    // 两者的较小值。
    localBookStatus.pageLastRead = MIN(self.currentPage, self.localBookInfo.downloadedPages - 1);
    localBookStatus.lastReadDate = [NSDate date];
    [[BRDBookShuff sharedObject] updateBookStatus:localBookStatus forKey:self.localBookKey];

    // 退出页面。
    [self dismissViewControllerAnimated:YES completion:nil];
    self.viewIsDismissed = YES;
    return;
}

// 开子线程逐步下载所有绘本页，直至全部下完或者绘本已经关闭。
- (void) downloadBookTillTopNPages {
    if (self.viewIsDismissed) {
        return;
    }
    
    if (self.localBookInfo.downloadedPages >= self.localBookInfo.totalPages) {
        return;
    }
    
    int lastPageToDownload = MIN(self.localBookInfo.downloadedPages  + kNumPagesNonFirstDownload, self.localBookInfo.totalPages);
    
    [[BRDBackendFactory getBookDownloader] downloadBook:self.localBookKey
                                              startPage:self.localBookInfo.downloadedPages + 1
                                                endPage:lastPageToDownload + 1
                                      withProgressBlock:^(BOOL finished, NSError *error, float percent) {
                                          if (finished) {
                                              if (error != nil) {
                                                  UIAlertView *alert =
                                                  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误", nil)
                                                                             message:@"无法下载更多的绘本页面，请检查网络。"
                                                                            delegate:self
                                                                   cancelButtonTitle:@"好的，知道了"
                                                                   otherButtonTitles:nil];
                                                  [alert show];
                                              } else {
                                                  NSLog(@"Download till page %d", lastPageToDownload);
                                                  
                                                  // 更新绘本的下载状态。
                                                  self.localBookInfo.downloadedPages = lastPageToDownload;
                                                  [[BRDBookShuff sharedObject] updateBook:self.localBookInfo
                                                                            forKey:self.localBookKey];
                                                  
                                                  // 隐藏旋转图标
                                                  if ([_spinner isAnimating]) {
                                                      [_spinner stopAnimating];
                                                      [self initializeFromCurrentPage:YES];
                                                  }
                                                  
                                                  [self downloadBookTillTopNPages];
                                              }
                                          }
                                      }];
    
}

// 重新载入绘本并跳转至当前页。
- (void) initializeFromCurrentPage:(BOOL) pageHasChanged {
    for (UIView *view in self.scrollView1.subviews) {
        [view removeFromSuperview];
    }
    
    NSUInteger numPages = MIN(self.localBookInfo.downloadedPages + 1, self.localBookInfo.totalPages);
    
    // 将ScrollView的高宽设置为与屏幕一致。
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect scrollFrame;
    scrollFrame.origin = self.scrollView1.frame.origin;
    scrollFrame.size = screenRect.size;
    self.scrollView1.frame = scrollFrame;
    
    // ScrollView的总宽为（宽度x页数）。
    self.scrollView1.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView1.frame) * numPages, CGRectGetHeight(self.scrollView1.frame));
    
    // 初始化所有页面视图。
    self.viewControllers = nil;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;

    // 跳转至当前页。
    [self gotoPage:pageHasChanged];
}

// 载入第(page)页
- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= [self.viewControllers count]) {
        return;
    }
    
    // 新建一个页面（BookPagePlayerVC），并插入到所有会本页的容器中 (self.viewControllers）。
    BookPagePlayerVC *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[BookPagePlayerVC alloc] initWithBookKey:self.localBookKey
                                                      withPage:(int)page
                                            withTranslatedText:self.translatedText];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // 将新建页(controller) 添加到scrollView1的子视图。
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView1.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        NSLog(@"Page = %lu, frame.x = %f", page, frame.origin.x);
        
        [self addChildViewController:controller];
        [self.scrollView1 addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
        [controller showPageAtIndex:(int)page];
    }
}

// 将制定绘本也从scrollView1的子视图集中移除。
- (void)removeChildController:(UIViewController *)controller
{
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

// 翻到第(self.currentPage)页。
- (void)gotoPage:(BOOL) pageHasChanged
{
    NSInteger page = self.currentPage;
    
    if (pageHasChanged) {
        [_spinner stopAnimating];
    }
    
    // 如果不是第一页，则载入前一页。
    if (page > 0) {
        [self loadScrollViewWithPage:page - 1];
    }
    
    // 载入当前页。
    [self loadScrollViewWithPage:page];
    
    // 如果不是最后一页，则载入后一页。
    if (page + 1 < self.localBookInfo.downloadedPages) {
        [self loadScrollViewWithPage:page + 1];
    }
    
    // 将第(page - 2)页和(page + 2) 页从Scroll View移除。这样可以防止内存溢出。
    for (int p = MAX(0, page - 2);
         p <= MIN(page + 2, self.viewControllers.count - 1); ++p)
    {
        BookPagePlayerVC *controller = [self.viewControllers objectAtIndex:p];
        if ((NSNull *)controller != [NSNull null]) {
            if (controller.page < (page - 1) ||
                controller.page > (page + 1))
            {
                [self removeChildController:controller];
                self.viewControllers[p] = [NSNull null];
            }
        }
    }
    
    // update the scroll view to the appropriate page
    CGRect bounds = self.scrollView1.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView1 scrollRectToVisible:bounds animated:pageHasChanged];
    
    if (pageHasChanged) {
        [self playPageAtIndex:page];
    }
}

// 播放该绘本页(pageIndex)对应的音频文件。
- (void) playPageAtIndex:(int) pageIndex {
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@-audio-%@.mp3",
                               [BRDPathUtil applicationDocumentsDirectoryPath],
                               self.localBookInfo.filePrefix,
                               [self intToString:pageIndex+1]];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    self.player = newPlayer;
    [self.player play];
}

// 将页码转换为4位数文件名后缀。
// TODO: 移植到公共函数区
- (NSString*) intToString:(int) integer {
    if (integer < 10) {
        return [NSString stringWithFormat:@"000%d", integer];
    } else if (integer < 100) {
        return [NSString stringWithFormat:@"00%d", integer];
    } else if (integer < 1000) {
        return [NSString stringWithFormat:@"0%d", integer];
    } else {
        return [NSString stringWithFormat:@"%d", integer];
    }
}

- (void) alertForLastPage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示"
                                                    message:@"已经翻到最后一页。向左滑动往后翻页, 向右滑动往前翻页, 长按屏幕返回。"
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) alertForFirstPage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示"
                                                    message:@"已经翻到第一页。 向左滑动往后翻页, 向右滑动往前翻页, 长按屏幕返回。"
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil];
    
    [alert show];
    
}

#pragma 响应弹出窗口的按钮事件

// 左上角 + 号点击事件
- (IBAction)buttonMenuClicked:(id)sender {
    [self.player stop];
    [self hidePopupButton:NO];
}

// 换书按钮点击事件
- (IBAction)exitButtonClicked:(id)sender {
    [self exitFromCurrentBook];
}

// 重读按钮点击事件
- (IBAction)replayButtonClicked:(id)sender {
    [self hidePopupButton:YES];
    
    self.player.currentTime = 0;
    [self.player play];
}

// 继续按钮点击事件
- (IBAction)resumeButtonClicked:(id)sender {
    [self resumePlay];
}

#pragma 弹出窗口按钮事件的辅助函数

// 坚持是否弹出窗口已经被隐藏。
- (BOOL) isPopupViewHidden {
    return !self.popupView;
}

// 隐藏弹出窗口
- (void) hidePopupButton:(BOOL) hide {
    if (hide) {
        [self.popupView removeFromSuperview];
        self.popupView = nil;
    } else {
        [self.view bringSubviewToFront:self.exitButton];
        
        [self.view bringSubviewToFront:self.replayButton];
        
        [self.view bringSubviewToFront:self.resumeButton];
        
        if ([self isPopupViewHidden]) {
            BookPlayerPopupSubVC* location = [[BookPlayerPopupSubVC alloc] initWithNibName:@"BookPlayerPopupSubVC" bundle:[NSBundle mainBundle]];
            
            self.popupView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
            
            self.popupView = location.view;
            self.popupView.frame = self.view.frame;
            [self.view addSubview:self.popupView];
            [self hidePopupButton:NO];
        }
        
    }
    
    
    [self.exitButton setHidden:hide];
    [self.replayButton setHidden:hide];
    [self.resumeButton setHidden:hide];
}

// 继续从刚才暂定的音点播放
- (void) resumePlay {
    [self hidePopupButton:YES];
    [self.player play];
}



@end
