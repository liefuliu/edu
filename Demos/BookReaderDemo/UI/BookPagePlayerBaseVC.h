//
//  BookPagePlayerBaseVC.h
//  BookReaderDemo
//
//  Created by Liefu Liu on 6/19/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalBook.h"

@interface BookPagePlayerBaseVC : UIViewController

@property int currentPage;
@property LocalBook* localBookInfo;
@property NSString* localBookKey;
@property NSArray* translatedText;

@property int page;

- (id) initWithBookKey:(NSString*) localBookKey
              withPage:(int) pageIndex
    withTranslatedText:(NSArray*) translatedText;

- (void) showPageAtIndex:(int) pageIndex;

@end
