//
//  BookShuffCollectionViewController.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 5/22/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BookShuffCollectionViewController.h"
#import "BookShuffCollectionViewCell.h"
#import "BRDColor.h"


#import "BRDBookShuff.h"
#import "BRDBookSummary.h"
#import "BRDFileUtil.h"
#import "BookItemCell.h"
#import "LocalBook.h"
#import "BookPlayerScrollVC.h"

@interface BookShuffCollectionViewController ()

@property NSArray* allBookKeys;
@end

@implementation BookShuffCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"BookShuffCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
    //self.collectionView.backgroundColor = [UIColor grayColor];
    
    self.title = @"书架";
    //[self loadBooksOnShuff];
    
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [self loadBooksOnShuff];
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
    if (section < 1) {
         return [self.allBookKeys count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 1) {
        BookShuffCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                       forIndexPath:indexPath];
        
        NSString* bookKey = self.allBookKeys[indexPath.row];
        LocalBook* bookInfo = [[BRDBookShuff sharedObject] getBook:bookKey];
        cell.bookNameLabel.text = [NSString stringWithFormat:@"%@", bookInfo.bookName];
        
        NSData* imageData = [BRDFileUtil getBookCoverImage:bookKey];
        cell.bookImageView.image = [[UIImage alloc] initWithData:imageData];
        [self setShadowToLayer:cell.bookImageView.layer];
        
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 6;
        
        [self setShadowToLayer:cell.layer];
        return cell;
    } else {
        return nil;
    }
}

- (void) setShadowToLayer: (CALayer*) layer {
    [layer setShadowColor:[UIColor blackColor].CGColor];
    [layer setShadowOpacity:0.8];
    [layer setShadowRadius:3.0];
    [layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    CGRect screenRect;
    screenRect.origin= [[UIScreen mainScreen] bounds].origin;
    screenRect.size = [self adjustedScreenSize];
    
    //if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
    size.width = screenRect.size.width / 3 - 10;
    //} else {
    //    size.width = (screenRect.size.height - 30) / 2;
    //}
    
    // There are 2 labels: book name and author, therefore set 70 to be the height.
    const int heightReservedForLabels = 30;
    size.height = (size.width - 10) * 4.0 / 3.0 + 10 + heightReservedForLabels;
    
    return size;
}



- (void) collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        BookPlayerScrollVC *detailViewController = [[BookPlayerScrollVC alloc] initWithBookKey:self.allBookKeys[indexPath.row]];
        [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}



- (CGSize)adjustedScreenSize {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    //    return CGSizeMake(screenSize.height, screenSize.width);
    // }
    return screenSize;
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


#pragma mark - Data processing
- (void) loadBooksOnShuff {
    self.allBookKeys = [[BRDBookShuff sharedObject] getAllBookKeys];
    [self.collectionView reloadData];
}


@end
