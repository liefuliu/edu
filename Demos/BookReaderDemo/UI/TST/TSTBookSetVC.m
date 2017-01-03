//
//  TSTBookSetVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/18/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//
#import "TSTBookSetVC.h"

#import "TSTBookVC.h"
#import "TSTBookSetCollectionViewCell.h"
#import "BRDBookLister.h"
#import "BRDBackendFactory.h"
#import "BRDListedBook.h"
#import "BRDBookSummary.h"
#import "BRDColor.h"
#import "BRDListedBookWithImage.h"
#import "ShadowUtil.h"

@interface TSTBookSetVC ()
@property NSString* bookSetId;
@property NSString* bookSetName;
@property NSString* bookSetSummary;
@property NSData* bookSetCoverImage;
@property NSMutableArray* bookListInSet;
@property NSMutableArray* bookInfoListInSet;
@end

@implementation TSTBookSetVC

static NSString * const reuseIdentifier = @"Cell";


static UIActivityIndicatorView *_indicatorView;

-(id) initWithBookSetId: (NSString*) bookSetId
            bookSetName: (NSString*) bookSetName
         bookSetSummary: (NSString*) bookSetSummary
      bookSetCoverImage: (NSData*) bookSetCoverImage{
    self = [super init];
    if (self) {
        self.bookSetId = bookSetId;
        self.bookSetName = bookSetName;
        self.bookSetSummary = bookSetSummary;
        self.bookSetCoverImage = bookSetCoverImage;
        self.bookListInSet = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"绘本系列";
    self.bookSetNameLabel.text = self.bookSetName;
    self.bookSetSummaryTextView.text = self.bookSetSummary;
    [self.bookSetSummaryTextView setTextColor:[UIColor darkGrayColor]];
    
    self.bookSetImageView.image = [UIImage imageWithData:self.bookSetCoverImage];
     [self.bookSetImageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.bookSetImageView.layer setShadowOpacity:0.8];
    [self.bookSetImageView.layer setShadowRadius:3.0];
    [self.bookSetImageView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [ShadowUtil setShadowToLayer:self.bookSetImageView.layer];
    
    self.bookDetailLabel.textColor = [BRDColor backgroundSkyBlue];
    
    //self.bookDetailLabel.layer.masksToBounds = YES;
    //self.bookDetailLabel.layer.cornerRadius = 5;
    //[ShadowUtil setShadowToLayer:self.bookDetailLabel.layer];
    
    //[self.bookDetailLabel setBackgroundColor:[BRDColor backgroundSkyBlue]];
    
    // TODO: add constraints
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int height = screenRect.size.height;
    int width = screenRect.size.width;
    int imageViewWidth = width / 3;
    int imageViewHeight = height / 4;
    
    int topOffset = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + 5;
    
    NSLog(@"height = %d, width =%d", height, width);
    
    self.bookCollectionView.delegate = self;
    self.bookCollectionView.dataSource = self;
    
    
    // Register cell classes
    UINib *cellNib = [UINib nibWithNibName:@"TSTBookSetCollectionViewCell" bundle:nil];
    [self.bookCollectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    
    NSDictionary *nameMap = @{@"imageView": self.bookSetImageView,
                              @"collectionView": self.bookCollectionView,
                              @"bookSetNameLabel": self.bookSetNameLabel,
                              @"textfield":self.bookSetSummaryTextView,
                              @"bookDetailLabel": self.bookDetailLabel};
    
    NSArray *horizontalConstraints1 =
    [NSLayoutConstraint constraintsWithVisualFormat:
      [NSString stringWithFormat:@"H:|-[imageView(%d)]-15-[bookSetNameLabel]-|", imageViewWidth]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *horizontalConstraints2 =
    [NSLayoutConstraint constraintsWithVisualFormat:
      [NSString stringWithFormat:@"H:|-[imageView(%d)]-10-[textfield]-|", imageViewWidth]
                                            options:0
                                            metrics:nil
                                              views:nameMap];

    
    NSArray *horizontalConstraints3 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     @"H:|-(5)-[collectionView]-(5)-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *verticalConstraints1 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"V:|-%d-[imageView(%d)]-20-[bookDetailLabel]-10-[collectionView]-|", topOffset, imageViewHeight]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *verticalConstraints2 =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[textfield]-20-[bookDetailLabel]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *verticalConstraints3 =
    [NSLayoutConstraint constraintsWithVisualFormat:
                                [NSString stringWithFormat:@"V:|-%d-[bookSetNameLabel]-10-[textfield]", topOffset]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *horizontalConstraints5 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     @"H:|-[bookDetailLabel(150)]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];

    [self.view removeConstraints:[self.view constraints]];
    
    [self.view addConstraints:horizontalConstraints1];
    [self.view addConstraints:horizontalConstraints2];
    [self.view addConstraints:horizontalConstraints3];
    [self.view addConstraints:horizontalConstraints5];
    [self.view addConstraints:verticalConstraints1];
    [self.view addConstraints:verticalConstraints2];
    [self.view addConstraints:verticalConstraints3];
    
    _indicatorView = [self showSimpleActivityIndicatorOnView:self.bookCollectionView withScreenWidth:width];
    [self tryLoadBookListInSet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_bookInfoListInSet count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0 ) {
        TSTBookSetCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier                      forIndexPath:indexPath];
        BRDListedBookWithImage* bookWithImage = [self.bookInfoListInSet objectAtIndex:indexPath.row];
        //cell.bookNameLabel.text = @"new book";
        cell.bookTitleTextView.text = bookWithImage.bookInfo.bookName;
        cell.bookTitleTextView.font = [UIFont boldSystemFontOfSize:10];
        cell.bookTitleTextView.textAlignment = NSTextAlignmentCenter;
        cell.bookImageView.image = [UIImage imageWithData:bookWithImage.bookSummaryWithImage.imageData];
        
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        return cell;
    } else {
        return nil;
    }
}



- (void) collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        TSTBookSetCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier                      forIndexPath:indexPath];
        
        BRDListedBookWithImage* bookWithImage = [self.bookInfoListInSet objectAtIndex:indexPath.row];
        
        TSTBookVC* bookSetVC = [[TSTBookVC alloc] initWithBookInfo: bookWithImage.bookInfo 
                                                       bookImage:bookWithImage.bookSummaryWithImage.imageData];
        [self.navigationController pushViewController:bookSetVC
                                             animated:YES];
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    size.width = screenRect.size.width / 3 - 10;
    
    size.height = size.width * 5 / 4 + 30;
    
    NSLog(@"scrren width = %f, height = %f", screenRect.size.width, screenRect.size.height);
    NSLog(@"size.width = %f, size.height = %f", size.width, size.height);
    return size;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) tryLoadBookListInSet {
    [self startLoadData];
    
    NSLog(@"tryLoadBookListInSet");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        id<BRDBookLister> bookLister = [BRDBackendFactory getBookLister];
        if (![bookLister connectToServer]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法连接到服务器" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        __block NSMutableArray* arrayOfBooks;
        [bookLister getListOfBooks:20 inBookSet:self.bookSetId to:&arrayOfBooks];
        
        // We get the main thread because drawing must be done in the main thread always
        dispatch_async(dispatch_get_main_queue(),^ {
            _bookListInSet = arrayOfBooks;
            [self.bookCollectionView reloadData];
            [self tryLoadBookImagesForNextPage];
        } );
        
    });
}

- (void) tryLoadBookImagesForNextPage {
    if (_bookInfoListInSet == nil) {
        _bookInfoListInSet = [[NSMutableArray alloc] init];
    }
    
    __block NSMutableArray* arrayOfBookToFetch = [[NSMutableArray alloc] init];
    for (int i = 0; i < _bookListInSet.count; i++) {
        [arrayOfBookToFetch addObject:((BRDListedBook*)_bookListInSet[i]).bookId];
    }
    
    NSLog(@"tryLoadBookImagesForNextPage");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        NSLog(@"enter dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),");
        
        id<BRDBookLister> bookLister = [BRDBackendFactory getBookLister];
        
        __block NSMutableDictionary* bookSummaryInfo = [[NSMutableDictionary alloc] init];
        [bookLister appendSummaryInfoForBooks:arrayOfBookToFetch to:&bookSummaryInfo];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            for (int i = 0;
                 i < [_bookListInSet count];
                 i++) {
                BRDListedBook* listedBook = (BRDListedBook*)_bookListInSet[i];
                BRDBookSummary* bookSummary = (BRDBookSummary*)[bookSummaryInfo objectForKey:listedBook.bookId];
                if (bookSummary != nil) {
                    BRDListedBookWithImage* bookWithImage = [[BRDListedBookWithImage alloc]
                                                             initBook:listedBook
                                                             withSummaryImage:bookSummary];
                    [_bookInfoListInSet addObject:bookWithImage];
                }
            }
            
            [self endLoadData];
            [self.bookCollectionView reloadData];
        } );
    });
}




- (void) startLoadData {
NSLog(@"activityIndicator: %@", _indicatorView);
    [_indicatorView startAnimating];
}

- (void) endLoadData {
    NSLog(@"activityIndicator: %@", _indicatorView);
    [_indicatorView stopAnimating];
}


- (UIActivityIndicatorView *)showSimpleActivityIndicatorOnView:(UIView*)aView
                                               withScreenWidth:(float) width
{
    // create new dialog box view and components
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // Put the indicator view on top (100 px from the top) center of the collection view.
    activityIndicatorView.center = CGPointMake(width / 2.0 - 10, 100);
    
    [aView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    return activityIndicatorView;
}



@end
