//
//  SQScrollViewController.h
//  SQScrollView
//
//  Created by Lingjunhou on 14-2-26.
//  Copyright (c) 2014年 LinjunHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleImageView.h"


/*这是一个确定图片滑到最左边或者最右边的状态量,以确定是否重新刷新数据 */
typedef enum _imageStatePosition
{
    AtLess = 0,
    AtNomal,
    AtMore
    
}imageStatePosition;

@interface SQScrollViewController : UIViewController <UIScrollViewDelegate,ScaleImageViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    

    UIScrollView * _scrollView;
    ScaleImageView * _fontScaleImage;
    ScaleImageView * _curScaleImage;
    ScaleImageView * _rearScaleImage;
    NSMutableArray * _curImageArray;
    
    imageStatePosition _imagestate;
}

- (id)initWithImageArray:(NSArray *)array andCurImage:(id) currentImage;

- (void)setImageViewthumbImage:(ScaleImageView *)scaleView withImage:(UIImage*)image;
- (void)setImageViewFullImage:(ScaleImageView *)scaleView withImage:(UIImage*)image byOrientation:(UIImageOrientation)orientation;
//- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(id)asset;
//for overLoad
//- (void)setImageViewthumbImage:(ScaleImageView *)scaleView withAsset:(id)asset;
//- (void)setImageViewFullImage:(ScaleImageView *)scaleView withAsset:(id)asset byOrientation:(UIImageOrientation)orientation;
- (CGSize)getIdentifyImageSizeWithImageView:(ScaleImageView *)scaleView isPortraitorientation:(BOOL)isPortrait;
- (void)getMoreAssetsWhenScrollLast;
- (void)getMoreAssetsWhenScrollFirst;
@end
