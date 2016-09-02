//
//  StoreBookSetTVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 8/30/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "StoreBookSetTVC.h"

#import "BRDBackendFactory.h"
#import "BRDColor.h"
#import "BRDConfig.h"
#import "BRDConstants.h"
#import "BRDOneBookSetCVC.h"

@interface StoreBookSetTVC ()


@end

@implementation StoreBookSetTVC


static NSString * const StoreBookSetTVC_ReuseIdentifier = @"Cell";

UIRefreshControl *_refreshControl;

// Element: BRDListedBook
NSArray* _bookList;

// Represent whether the collection view is loading the data. If Yes, pagination won't be triggered even when
// we scroll to bottom.
BOOL _isLoadingData;

// Element: BRDListedBookWithImage
NSMutableArray* _bookSetList;

NSTimer* _firstLoadingTimer;

// Represents the current page Number. To save the network traffic, collection view is rendered in pagination mode:
// Only when user scrolls down to close to the bottom, next pages will be load.
int _currentPage;

// Represents number of images to load in one page.
const int kNumberOfImagesToLoad = 10;

// When we scroll down the last but (kPreloadWhenOnlyTheseImagesLeft), pagination will be triggered. The number must
// be less than kNumberOfImagesToLoad.
const int kPreloadWhenOnlyTheseImagesLeft = 2;

// Height of collection view cell.
const int kCollectionViewCellHeight = 160;

UIActivityIndicatorView *_indicatorView;
NSTimer* _myTimer;


- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绘本馆";
    
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"StoreBookSetTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:StoreBookSetTVC_ReuseIdentifier];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    
    /*_myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];*/
    _indicatorView = [self showSimpleActivityIndicatorOnView:self.view];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(dragDownAndRefresh)
              forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"老绘本馆";
    
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
    [self tryLoadBookSetFullList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bookSetList.count;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int contentOffsetY = self.tableView.contentOffset.y;
    int contentSizeHeight = self.tableView.contentSize.height;
    int boundsSizeHeight = self.tableView.bounds.size.height;
    
    // NSLog(@"scrollViewDidScroll: %d, %d, %d", contentOffsetY, contentSizeHeight, boundsSizeHeight);
    
    if (!_isLoadingData) {
        if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height -
                                                   kCollectionViewCellHeight * kPreloadWhenOnlyTheseImagesLeft)) {
            NSLog(@" scroll to bottom!");
            [self tryLoadBookImagesForNextPage];
        }
    }
}



- (void) startRefresh :(UIBarButtonItem *)sender {
    NSLog(@"north star");
    [_indicatorView startAnimating];
    [self tryLoadBookSetFullList];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString* bookSetId = (NSString*) _bookSetList[indexPath.row];
    
        BRDOneBookSetCVC* oneBookSetVC = [[BRDOneBookSetCVC alloc] initWithBookSetId:bookSetId];
        [self.navigationController presentViewController:oneBookSetVC animated:YES completion:nil];
    }

}


// 响应屏幕90度旋转的操作。
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}

#pragma mark <UICollectionViewDelegate>


// TODO: 删除在主页中处理downlaodComplete的事件。
- (void) downloadComplete: (NSString*) bookKeyUnused
             forTopNPages:(int)pagesDownloaded {
    // We should keep more info about the book.
    /*
    NSArray *arrayOfIndexPaths = [self.tableView indexPathForSelectedRow];
    NSIndexPath *indexPathImInterestedIn = [arrayOfIndexPaths firstObject];
    BRDListedBookSet* bookSetInfo = ((BRDListedBookSet*)[_bookSetList objectAtIndex:indexPathImInterestedIn.row]).bookInfo;
    
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
     */
    
    
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
-(void) tryLoadBookSetFullList {
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
        
        __block NSArray* arrayOfBookSets;
        [bookLister getListOfBookSets:100 startFrom:0 to:&arrayOfBookSets];
        
        // We get the main thread because drawing must be done in the main thread always
        dispatch_async(dispatch_get_main_queue(),^ {
            _bookSetList = arrayOfBookSets;
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
    if (_bookSetList == nil) {
        _bookSetList = [[NSMutableArray alloc] init];
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
                    [_bookSetList addObject:bookWithImage];
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



@end
