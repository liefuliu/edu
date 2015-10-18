//
//  MyCusViewController.m
//  SQScrollView
//
//  Created by Lingjunhou on 14-2-26.
//  Copyright (c) 2014年 LinjunHou. All rights reserved.
//

#import "MyCusViewController.h"

@interface MyCusViewController ()

@end

@implementation MyCusViewController

- (void)imageViewScale:(ScaleImageView *)imageScale clickCurImage:(UIImageView *)imageview
{
    
}
- (void)setImageViewthumbImage:(ScaleImageView *)scaleView withImage:(id)image
{
    scaleView.imageView.image = (UIImage*)image;
}
- (void)setImageViewFullImage:(ScaleImageView *)scaleView withImage:(id)image byOrientation:(UIImageOrientation)orientation
{
    scaleView.imageView.image = (UIImage*) image;

}
- (CGSize)getIdentifyImageSizeWithImageView:(ScaleImageView *)scaleView isPortraitorientation:(BOOL)isPortrait
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    int imageWidth = scaleView.imageView.image.size.width;
    int imageHeight = scaleView.imageView.image.size.height;

    CGRect frameRect = CGRectZero;
    CGRect rect = CGRectZero;
    if (!isPortrait) {
        frameRect = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
        CGFloat scale = MIN(frameRect.size.width * 1.0/imageWidth, frameRect.size.height * 1.0/imageHeight);
        rect = CGRectMake(0, 0, imageWidth * scale,   imageHeight * scale);
        
    } else {
        frameRect = screenFrame;
        
        CGFloat scale = MIN(frameRect.size.width * 1.0/imageWidth, frameRect.size.height * 1.0/imageHeight);
        rect = CGRectMake(0, 0, imageWidth * scale, imageHeight  * scale);
    }
    
    return rect.size;

}
- (void)getMoreAssetsWhenScrollLast
{
    return;
}
- (void)getMoreAssetsWhenScrollFirst
{
    return;
}

@end
