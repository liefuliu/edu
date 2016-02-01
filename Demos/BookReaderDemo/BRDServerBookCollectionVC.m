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
#import "BRDLocalStore.h"
#import "BRDBookLister.h"
#import "BRDBookSummary.h"
#import "ServerBook.h"

@interface BRDServerBookCollectionVC ()

@end

@implementation BRDServerBookCollectionVC

static NSString * const reuseIdentifier = @"Cell";

NSArray* _bookList;
NSDictionary* _bookCoverImages;

UIActivityIndicatorView *_indicatorView;
NSTimer* _myTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"ServerBookListCVC" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    
    // Do any additional setup after loading the view.
    
    // bar.topItem.title = @"title text";
    self.title = @"绘本集";
    
    /*_myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];*/
    _indicatorView = [self showSimpleActivityIndicatorOnView:self.view];
    
    [self tryLoadBookList];
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
    return _bookList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0 ) {
        ServerBookListCVC* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                             forIndexPath:indexPath];
        
        ServerBook* bookInfo = [_bookList objectAtIndex:indexPath.row];
        
        //cell.statusLabel.text = bookInfo.author;
        // cell.topicLabel.text = bookInfo.bookName;
        BRDBookSummary* bookSummary = (BRDBookSummary*)[_bookCoverImages objectForKey:bookInfo.bookId];
        
        if (bookSummary) {
            cell.imageView.image = [[UIImage alloc] initWithData: bookSummary.imageData];
        }
        
        
        return cell;
    } else {
        return nil;
    }    // Configure the cell
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    size.height = 100;
    size.width = 100;
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
        ServerBook* bookInfo = [_bookList objectAtIndex:indexPath.row];
        
        if ([[BRDLocalStore sharedObject] isBookDownloaded:[bookInfo bookId]]) {
            BookPlayerScrollVC *detailViewController = [[BookPlayerScrollVC alloc] initWithBookKey:bookInfo.bookId];
            [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
            
        } else {
            BookDownloadWaitVC* waitingVC = [[BookDownloadWaitVC alloc] initWithBookKey:[bookInfo bookId]];
            waitingVC.delegate = self;
            [self.navigationController presentViewController:waitingVC animated:nil completion:nil];
        }
    }
}

#pragma mark <UICollectionViewDelegate>





- (void) downloadComplete: (NSString*) bookKey {
    [[BRDLocalStore sharedObject] markBookAsDownloaded:bookKey];
    BookPlayerScrollVC *detailViewController = [[BookPlayerScrollVC alloc] initWithBookKey:bookKey];
    [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
}


-(void) tryLoadBookList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        
        BRDBookLister* bookLister = [[BRDBookLister alloc] init];
        if (![bookLister connectToServer]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法连接到服务器" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        __block NSArray* arrayOfBooks;
        
        [bookLister getListOfBooks:100 startFrom:0 to:&arrayOfBooks];
        for (NSString* bookName in arrayOfBooks) {
            NSLog(@"book name:%@", bookName);
        }
        
        //we get the main thread because drawing must be done in the main thread always
        dispatch_async(dispatch_get_main_queue(),^ {
            // [cell.imageView setImage:cellImage];
            _bookList = arrayOfBooks;
            [_indicatorView stopAnimating];
            
            [self tryLoadBookImages];
        } );
        
    });
}

- (void) tryLoadBookImages {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        BRDBookLister* bookLister = [[BRDBookLister alloc] init];
        __block NSDictionary* bookSummaryInfo;
        
        NSMutableArray* arrayOfBookId = [[NSMutableArray alloc] init];
        for (ServerBook* book in _bookList) {
            [arrayOfBookId addObject:book.bookId];
        }
        
        [bookLister getSummaryInfoForBooks:arrayOfBookId to:&bookSummaryInfo];
        /*
         for (NSString* bookName in arrayOfBooks) {
         NSLog(@"book name:%@", bookName);
         }*/
        
        //we get the main thread because drawing must be done in the main thread always
        dispatch_async(dispatch_get_main_queue(),^ {
            // [cell.imageView setImage:cellImage];
            _bookCoverImages = bookSummaryInfo;
            
            [self.collectionView reloadData];
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
