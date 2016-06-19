//
//  BookPagePlayerBaseVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 6/19/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BookPagePlayerBaseVC.h"
#import "BRDBookShuff.h"
@interface BookPagePlayerBaseVC ()

@end

@implementation BookPagePlayerBaseVC


- (id) initWithBookKey:(NSString*) localBookKey
              withPage:(int) pageIndex
    withTranslatedText: (NSArray*) translatedText {
    if (self = [super init]) {
        self.localBookKey = localBookKey;
        self.localBookInfo = [[BRDBookShuff sharedObject] getBook:self.localBookKey];
        self.page = pageIndex;
        self.translatedText = translatedText;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
