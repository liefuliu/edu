//
//  TestView.m
//  TestCircularProgress
//
//  Created by Liefu Liu on 1/24/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "CircularProgressView.h"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@interface CircularProgressView () {
    CGFloat startAngle;
    CGFloat endAngle;
}

@end

@implementation CircularProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // Determine our start and stop angles for the arc (in radians)
        startAngle = M_PI * 1.5;
        endAngle = startAngle + (M_PI * 2);
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    const float kRadius = MIN(rect.size.width, rect.size.height) * 0.45;
    const int kLineWidth = 10;
    
    // 画出没有完成的部分
    UIBezierPath* bezierPathUnfinished = [UIBezierPath bezierPath];
    
    // 创建圆弧对象，逆时针方向。
    [bezierPathUnfinished addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:kRadius
                      startAngle:startAngle
                        endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                       clockwise:NO];
    
    // 设定圆弧颜色。
    bezierPathUnfinished.lineWidth = kLineWidth;
    [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] setStroke];
    [bezierPathUnfinished stroke];
    
    // 画出已完成的部分
    UIBezierPath* bezierPathComplete = [UIBezierPath bezierPath];
    
    // 创建圆弧对象，顺时针方向。
    [bezierPathComplete addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                                    radius:kRadius
                                startAngle:startAngle
                                  endAngle:(endAngle - startAngle) * (_percent / 100.0) + startAngle
                                 clockwise:YES];
    
    // 设定圆弧颜色。
    bezierPathComplete.lineWidth = kLineWidth;
    [[UIColor colorWithRed:0 green:0.5 blue:0.75 alpha:1.0] setStroke];
    [bezierPathComplete stroke];
    
    // 用文字显示进度百分比。
    NSString* textContent = [NSString stringWithFormat:@"%d%%", self.percent];

    CGRect textRect = CGRectMake((rect.size.width / 2.0) - 71/2.0, (rect.size.height / 2.0) - 30/2.0, 71, 30);
    [[UIColor blackColor] setFill];
    [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 30] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}

@end
