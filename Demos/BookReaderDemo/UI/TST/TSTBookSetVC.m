//
//  TSTBookSetVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/18/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "TSTBookSetVC.h"
#import "TSTBookSetCollectionViewCell.h"

@interface TSTBookSetVC ()
@property NSString* bookSetId;
@property NSString* bookSetName;
@property NSString* bookSetSummary;
@property NSData* bookSetCoverImage;
@end

@implementation TSTBookSetVC

static NSString * const reuseIdentifier = @"Cell";

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"绘本系列";
    self.bookSetNameLabel.text = self.bookSetName;
    self.bookSetSummaryTextView.text = self.bookSetSummary;
    self.bookSetImageView.image = [UIImage imageWithData:self.bookSetCoverImage];
    
    // TODO: add constraints
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int height = screenRect.size.height;
    int width = screenRect.size.width;
    int imageViewWidth = width / 3;
    int imageViewHeight = height / 4;
    
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
     @"H:|-[collectionView]-|"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *verticalConstraints1 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     [NSString stringWithFormat:@"V:|-80-[imageView(%d)]-20-[bookDetailLabel]-20-[collectionView]-50-|", imageViewHeight]
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    NSArray *verticalConstraints2 =
    [NSLayoutConstraint constraintsWithVisualFormat:
                                @"V:|-80-[bookSetNameLabel]-10-[textfield(100)]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];
    
    NSArray *horizontalConstraints4 =
    [NSLayoutConstraint constraintsWithVisualFormat:
     @"H:|-50-[bookDetailLabel(150)]"
                                            options:0
                                            metrics:nil
                                              views:nameMap];

    [self.view removeConstraints:[self.view constraints]];
    
    [self.view addConstraints:horizontalConstraints1];
    [self.view addConstraints:horizontalConstraints2];
    
    [self.view addConstraints:horizontalConstraints3];
    
    [self.view addConstraints:horizontalConstraints4];
    [self.view addConstraints:verticalConstraints1];
    [self.view addConstraints:verticalConstraints2];
    

    
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
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0 ) {
        TSTBookSetCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier                      forIndexPath:indexPath];
        
        //cell.bookNameLabel.text = @"new book";
        cell.bookNameLabel.text =self.bookSetName;
        cell.bookImageView.image = [UIImage imageWithData:self.bookSetCoverImage];
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
    
    size.width = screenRect.size.width / 4 - 15;
    
    size.height = 150;
    
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

@end
