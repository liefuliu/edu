//
//  TSTPictureBookStoreVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 11/20/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "TSTPictureBookStoreVC.h"
#import "TSTPictureBookStoreCell.h"
#import "BRDColor.h"
#import "BRDListedBookSet.h"
#import "BRDBookLister.h"
#import "BRDBackendFactory.h"
#import "TSTBookSetVC.h"

@interface TSTPictureBookStoreVC ()

@end

@implementation TSTPictureBookStoreVC

static NSString * const reuseIdentifier = @"Cell";

// Height of collection view cell.
static int const kCollectionViewCellHeight = 240;

static UIActivityIndicatorView *_indicatorView;

// Element: BRDListedBookSet
static NSMutableArray* _bookSetInfoList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"绘本馆";
    
    self.navigationController.navigationBar.barTintColor = [BRDColor backgroundSkyBlue];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Register cell classes
    UINib *cellNib = [UINib nibWithNibName:@"TSTPictureBookStoreCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];

    
    // Do any additional setup after loading the view.
    _indicatorView = [self showSimpleActivityIndicatorOnView:self.view];
    
    _bookSetInfoList = [[NSMutableArray alloc] init];
    [self tryLoadBookFullList];
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
    return [_bookSetInfoList count];
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    size.width = screenRect.size.width / 2 - 10;
    size.height = kCollectionViewCellHeight;
    
    return size;
}

- (void) collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        TSTPictureBookStoreCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                  forIndexPath:indexPath];
        BRDListedBookSet* bookSetWithImage = [_bookSetInfoList objectAtIndex:indexPath.row];
        NSLog(@"Book set %@ selected. ", bookSetWithImage.bookSetId);
        
        TSTBookSetVC* bookSetVC = [[TSTBookSetVC alloc] initWithBookSetId: bookSetWithImage.bookSetId
             bookSetName: bookSetWithImage.bookSetName bookSetSummary:bookSetWithImage.bookSetNotes
                 bookSetCoverImage:bookSetWithImage.sampleBookCoverImage];
        [self.navigationController pushViewController:bookSetVC
                                             animated:YES];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0 ) {
        TSTPictureBookStoreCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                            forIndexPath:indexPath];
        BRDListedBookSet* bookSetWithImage = [_bookSetInfoList objectAtIndex:indexPath.row];
        
        if (bookSetWithImage) {
            cell.sampleBookImageView.image = [[UIImage alloc] initWithData: bookSetWithImage.sampleBookCoverImage];
            cell.bookSetTitleTextField.text = bookSetWithImage.bookSetName;
            cell.bookSetNotesTextView.text = [self getTruncatedString:bookSetWithImage.bookSetNotes];
        }
        
        return cell;
    } else {
        return nil;
    }
}

- (NSString*) getTruncatedString: (NSString*) originalString {
    if (originalString.length <= 30) {
        return originalString;
    }
    
    return [NSString stringWithFormat:@"%@...", [originalString substringToIndex:20]];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5,5);
}

#pragma mark <UICollectionViewDelegate>

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

# pragma mark UIActivityIndicatorView setup

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


// TODO(liefuliu): Set time out for tryLoadBoookList, and throw an alert when time out.
-(void) tryLoadBookFullList {
    [self startLoadData];
    
    NSLog(@"tryLoadBookList");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        id<BRDBookLister> bookLister = [BRDBackendFactory getBookLister];
        if (![bookLister connectToServer]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法连接到服务器" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        __block NSArray* arrayOfBooks;
        [bookLister getListOfBookSets:20 to:&arrayOfBooks];
        
        // We get the main thread because drawing must be done in the main thread always
        dispatch_async(dispatch_get_main_queue(),^ {
            _bookSetInfoList = arrayOfBooks;
            [self endLoadData];
            [self.collectionView reloadData];
        } );
        
    });
}


- (void) startLoadData {
    [_indicatorView startAnimating];
    //_isLoadingData = true;
}

- (void) endLoadData {
    [_indicatorView stopAnimating];
    //_isLoadingData = false;
}

@end
