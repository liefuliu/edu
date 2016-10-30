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
#import "StoreBookSetTableViewCell.h"
#import "BRDListedBookSet.h"

@interface StoreBookSetTVC ()


// Element: BRDListedBookSet
//@property NSArray* bookList;

// Represent whether the collection view is loading the data. If Yes, pagination won't be triggered even when
// we scroll to bottom.
@property BOOL isLoadingData;

// Element: BRDListedBookWithImage
@property NSMutableArray* bookSetList;

@property NSTimer* firstLoadingTimer;

@property UIActivityIndicatorView *indicatorView;

@end

@implementation StoreBookSetTVC

UIRefreshControl *_StoreBookSetTVCRefreshControl;

static NSString * const StoreBookSetTVC_ReuseIdentifier = @"StoreBookSetTableViewCell";


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
    UINib *cellNib = [UINib nibWithNibName:StoreBookSetTVC_ReuseIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:StoreBookSetTVC_ReuseIdentifier];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    
    _indicatorView = [self showSimpleActivityIndicatorOnView:self.view];
    
    _StoreBookSetTVCRefreshControl = [[UIRefreshControl alloc] init];
    [_StoreBookSetTVCRefreshControl addTarget:self action:@selector(dragDownAndRefresh)
              forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_StoreBookSetTVCRefreshControl];
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(doneApplication:)];
    [[self navigationItem] setLeftBarButtonItem:newBackButton];
    
    
    
    UIBarButtonItem* refreshButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(startRefresh:)];
    [self.navigationItem setRightBarButtonItem:refreshButton];
    
    _isLoadingData = false;
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StoreBookSetTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:StoreBookSetTVC_ReuseIdentifier
                                                             forIndexPath:indexPath];
        BRDListedBookSet* bookSet = (BRDListedBookSet*)self.bookSetList[indexPath.row];
        
        cell.statusLabel.text = bookSet.bookSetName;
        cell.topicLabel.text = bookSet.bookSetNotes;
        return cell;
    } else {
        return nil;
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
    
    NSLog(@"tryLoadBookSetFullList");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        id<BRDBookLister> bookLister = [BRDBackendFactory getBookLister];
        if (![bookLister connectToServer]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法连接到服务器" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        __block NSArray* arrayOfBookSets;
        [bookLister getListOfBookSets:100 startFrom:0 to:&arrayOfBookSets];
        _bookSetList = arrayOfBookSets;
        [self.refreshControl endRefreshing];
        [_firstLoadingTimer invalidate];
        [self endLoadData];
    });
}

- (void) startLoadData {
    [_indicatorView startAnimating];
    _isLoadingData = true;
}

- (void) endLoadData {
    [_indicatorView stopAnimating];
    _isLoadingData = false;
    [self.tableView reloadData];
}

@end
