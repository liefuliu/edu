//
//  SRXImageScrollViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 10/17/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXImageScrollViewController.h"

@interface SRXImageScrollViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray* imageArray;

@property UIScrollView *scrollview;

@end

@implementation SRXImageScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self anyFunction];
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


- (instancetype) initWithImageArray: (NSArray*) imageArray {
    self = [super init];
    if (self) {
        _imageArray = imageArray;
    }
    return self;
}

- (instancetype) initWithImage: (UIImage*) image {
    self = [super init];
    if (self) {
        _imageArray = [[NSMutableArray alloc] init];
        [_imageArray addObject:image];
    }
    return self;
    
}



- (void)anyFunction
{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, 320, 50)];
    NSInteger viewcount = [_imageArray count]; // if you have four content your view count is 4..(four)..in my case i fetch it from database
    
    CGFloat y2 = 0;
    UIView *view;
    UIImageView *imageView;
    NSString *imageName;
    
    for(int i = 0; i< viewcount; i++)
    {
        CGFloat y = i * 64;
        y2 = y2 + 64;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(y, 0, y2, 50)];
        
        imageName = [[NSString alloc] initWithFormat:@"c%i", (i + 1)]; // my image name is c1, c2, c3, c4 so i use this
        
        UIImage *image1 = [UIImage imageNamed:imageName];
        imageView = [[UIImageView alloc] initWithImage:image1];
        [view addSubview:imageView];
        [_scrollview addSubview:view];
    }
    
    _scrollview.contentSize = CGSizeMake(viewcount*64,0);  //viewcount*64 because i use image width 64..and  second parameter is 0..because i not wants vertical scrolling...
    [self.view addSubview:_scrollview];}

@end
