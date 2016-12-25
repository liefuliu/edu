//
//  TSTBookSetVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/18/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSTBookSetVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bookSetImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookSetNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *bookDetailLabel;
@property (weak, nonatomic) IBOutlet UITextView *bookSetSummaryTextView;



-(id) initWithBookSetId: (NSString*) bookSetId
            bookSetName: (NSString*) bookSetName
         bookSetSummary: (NSString*) bookSetSummary
      bookSetCoverImage: (NSData*) bookSetImage;

@end
