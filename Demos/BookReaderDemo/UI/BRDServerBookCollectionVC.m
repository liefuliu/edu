// Display loading & refreshing after lunch!

//
//  BRDServerBookCollectionVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/31/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDServerBookCollectionVC.h"
#import "ServerBookListCVC.h"
#import "BookPlayerScrollVC.h"
#import "BRDBookShuff.h"
#import "BRDBookSummary.h"
#import "BRDConstants.h"
#import "BRDListedBook.h"
#import "BRDListedBookWithImage.h"

#import "BRDBackendFactory.h"
#import "BRDColor.h"
#import "BRDConfig.h"

@interface BRDServerBookCollectionVC ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;

@end

@implementation BRDServerBookCollectionVC

static NSString * const reuseIdentifier = @"Cell";


// Element: BRDListedBook
NSArray* _bookList;

// Represent whether the collection view is loading the data. If Yes, pagination won't be triggered even when
// we scroll to bottom.
BOOL _isLoadingData;

// Element: BRDListedBookWithImage
NSMutableArray* _bookInfoList;

NSTimer* _firstLoadingTimer;

// Represents the current page Number. To save the network traffic, collection view is rendered in pagination mode:
// Only when user scrolls down to close to the bottom, next pages will be load.
int _currentPage;

// Represents number of images to load in one page.
const int kNumberOfImagesToLoad = 5;

// When we scroll down the last but (kPreloadWhenOnlyTheseImagesLeft), pagination will be triggered. The number must
// be less than kNumberOfImagesToLoad.
const int kPreloadWhenOnlyTheseImagesLeft = 2;

// Height of collection view cell.
const int kCollectionViewCellHeight = 160;

UIActivityIndicatorView *_indicatorView;
NSTimer* _myTimer;


- (void) viewWillAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.barTintColor = [BRDColor backgroundSkyBlue];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kNSDefaultsFirstLaunch])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNSDefaultsFirstLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作提示"
                                                        message:@"向下滑动刷新绘本"
                                                       delegate:self
                                              cancelButtonTitle:@"好的，知道了"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"ServerBookListCVC" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    
    /*_myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];*/
    _indicatorView = [self showSimpleActivityIndicatorOnView:self.view];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(dragDownAndRefresh)
              forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.title = @"绘本馆";
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(doneApplication:)];
    [[self navigationItem] setLeftBarButtonItem:newBackButton];

    
    
    UIBarButtonItem* refreshButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(startRefresh:)];
    [self.navigationItem setRightBarButtonItem:refreshButton];
    
    _isLoadingData = false;
    _currentPage = 0;
    [self tryLoadBookFullList];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int contentOffsetY = self.collectionView.contentOffset.y;
    int contentSizeHeight = self.collectionView.contentSize.height;
    int boundsSizeHeight = self.collectionView.bounds.size.height;
    
    // NSLog(@"scrollViewDidScroll: %d, %d, %d", contentOffsetY, contentSizeHeight, boundsSizeHeight);
    
    if (!_isLoadingData) {
    if(self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height -
                                               kCollectionViewCellHeight * kPreloadWhenOnlyTheseImagesLeft)) {
        NSLog(@" scroll to bottom!");
        [self tryLoadBookImagesForNextPage];
    }
    }
}



- (void) startRefresh :(UIBarButtonItem *)sender {
    NSLog(@"north star");
    [_indicatorView startAnimating];
    [self tryLoadBookFullList];
}

- (void) dragDownAndRefresh {
    NSLog(@"Warning: dragDownAndRefresh is disabled.");
}



- (void)doneApplication:(UIBarButtonItem *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"感谢您的使用"
                                                    message:@"确定要离开App么?"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
            //do something?
            break;
        case 1: //"Yes" pressed
            //here you pop the viewController
            exit(0);
            break;
    }
}


- (UIActivityIndicatorView *)showSimpleActivityIndicatorOnView:(UIView*)aView
{
    CGSize viewSize = aView.bounds.size;
    
    // create new dialog box view and components
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicatorView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    
    [aView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    return activityIndicatorView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return _bookInfoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0 ) {
        ServerBookListCVC* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                            forIndexPath:indexPath];
        BRDListedBookWithImage* bookWithImage = [_bookInfoList objectAtIndex:indexPath.row];
        BRDListedBook* bookInfo = bookWithImage.bookInfo;
        
        BRDBookSummary* bookSummary = bookWithImage.bookSummaryWithImage;
        
        if (bookSummary) {
            cell.imageView.image = [[UIImage alloc] initWithData: bookSummary.imageData];
            cell.bookNameLabel.text = bookInfo.bookName;
            cell.authorLabel.text = bookInfo.author;
            // TODO(liefuliu): Add summary.
        }
        
        
        return cell;
    } else {
        return nil;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    size.width = screenRect.size.width - 30;
    size.height = kCollectionViewCellHeight;
    
    return size;
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}


- (void) collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        [_indicatorView stopAnimating];
        [_firstLoadingTimer invalidate];
        
        BRDListedBook* bookInfo = ((BRDListedBookWithImage*)[_bookInfoList objectAtIndex:indexPath.row]).bookInfo;
        
        if ([[BRDConfig sharedObject] directlyOpenBookPages] || [[BRDBookShuff sharedObject] doesBookExist:[bookInfo bookId]]) {
            [self downloadComplete: @"bookKeyUnused"
                      forTopNPages:0];
        } else {
            BookDownloadWaitVC* waitingVC = [[BookDownloadWaitVC alloc] initWithBookKey:[bookInfo bookId]];
            waitingVC.delegate = self;
            [self.navigationController presentViewController:waitingVC animated:nil completion:nil];
        }
    }
}



// 响应屏幕90度旋转的操作。
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDelegate>


// TODO: 删除在主页中处理downlaodComplete的事件。
- (void) downloadComplete: (NSString*) bookKeyUnused
             forTopNPages:(int)pagesDownloaded {
    // We should keep more info about the book.
    NSArray *arrayOfIndexPaths = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *indexPathImInterestedIn = [arrayOfIndexPaths firstObject];
    BRDListedBook* bookInfo = ((BRDListedBookWithImage*)[_bookInfoList objectAtIndex:indexPathImInterestedIn.row]).bookInfo;
    
    NSString* bookKey = [bookInfo bookId];
    if (![[BRDBookShuff sharedObject] doesBookExist:[bookInfo bookId]]) {
    LocalBook* localBook = [[LocalBook alloc]
                            initBook:bookInfo.bookName
                            author:bookInfo.author
                            totalPages:bookInfo.totalPages
                            downloadedPages:pagesDownloaded
                            filePrefix:bookInfo.bookId hasTranslatedText:YES
                            imageFileType:bookInfo.imageFileType];
    [[BRDBookShuff sharedObject] addBook:localBook forKey:bookKey];
    }
    
    BookPlayerScrollVC *detailViewController = [[BookPlayerScrollVC alloc] initWithBookKey:bookKey];
    [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
}

#pragma mark initialize the view

- (void) cancelLoading {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"下载超时，请检查网络后向下滑动刷新。" delegate:self cancelButtonTitle:@"好的，知道了" otherButtonTitles:nil];
    [alert show];
    [_indicatorView stopAnimating];
    [self.refreshControl endRefreshing];
    return;

}

// TODO(liefuliu): Set time out for tryLoadBoookList, and throw an alert when time out.
-(void) tryLoadBookFullList {
    [self startLoadData];
    _firstLoadingTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutBookFirstLoad target:self selector:@selector(cancelLoading) userInfo:nil repeats:NO];
    
    NSLog(@"tryLoadBookList");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        id<BRDBookLister> bookLister = [BRDBackendFactory getBookLister];
        if (![bookLister connectToServer]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法连接到服务器" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        __block NSArray* arrayOfBooks;
        [bookLister getListOfBooks:100 startFrom:0 to:&arrayOfBooks];
        
        // We get the main thread because drawing must be done in the main thread always
        dispatch_async(dispatch_get_main_queue(),^ {
            _bookList = arrayOfBooks;
            [self tryLoadBookImagesForNextPage];
        } );
        
    });
}

- (void) startLoadData {
    [_indicatorView startAnimating];
    _isLoadingData = true;
}

- (void) endLoadData {
    [_indicatorView stopAnimating];
    _isLoadingData = false;
}

- (void) tryLoadBookImagesForNextPage {
    [self startLoadData];
    if (_bookInfoList == nil) {
        _bookInfoList = [[NSMutableArray alloc] init];
    }
    
    __block NSMutableArray* arrayOfBookToFetch = [[NSMutableArray alloc] init];
    for (int i = _currentPage * kNumberOfImagesToLoad;
         i < MIN((_currentPage + 1) * kNumberOfImagesToLoad, [_bookList count]);
         i++) {
        [arrayOfBookToFetch addObject:((BRDListedBook*)_bookList[i]).bookId];
    }
    
    NSLog(@"tryLoadBookImagesForNextPage");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        NSLog(@"enter dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),");
        
        id<BRDBookLister> bookLister = [BRDBackendFactory getBookLister];
        
        __block NSMutableDictionary* bookSummaryInfo = [[NSMutableDictionary alloc] init];
        [bookLister appendSummaryInfoForBooks:arrayOfBookToFetch to:&bookSummaryInfo];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            for (int i = _currentPage * kNumberOfImagesToLoad;
                 i < MIN((_currentPage + 1)* kNumberOfImagesToLoad, [_bookList count]);
                 i++) {
                BRDListedBook* listedBook = (BRDListedBook*)_bookList[i];
                BRDBookSummary* bookSummary = (BRDBookSummary*)[bookSummaryInfo objectForKey:listedBook.bookId];
                if (bookSummary != nil) {
                    BRDListedBookWithImage* bookWithImage = [[BRDListedBookWithImage alloc]
                                                         initBook:listedBook
                                                         withSummaryImage:bookSummary];
                    [_bookInfoList addObject:bookWithImage];
                }
            }
            
            if (_currentPage == 0) {
                [_firstLoadingTimer invalidate];
                [_indicatorView stopAnimating];
                [self.refreshControl endRefreshing];
            }
            ++_currentPage;
            [self.collectionView reloadData];
            [self endLoadData];
        } );
    });
}


/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
