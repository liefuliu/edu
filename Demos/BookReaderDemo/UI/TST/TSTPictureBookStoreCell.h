//
//  TSTPictureBookStoreCell.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 11/20/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSTPictureBookStoreCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sampleBookImageView;
@property (weak, nonatomic) IBOutlet UITextView *bookSetNotesTextView;
@property (weak, nonatomic) IBOutlet UITextField *bookSetTitleTextField;

@end
