//
//  StoreBookSetTableViewCell.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 8/31/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreBookSetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookSetImage;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
