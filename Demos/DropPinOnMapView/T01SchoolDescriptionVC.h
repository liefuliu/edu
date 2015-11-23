//
//  T01SchoolDescriptionVC.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 11/14/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol T01SchoolDescriptionVCDelegate <NSObject>
- (void) descriptionEntered:(NSString*) description;
@end

@interface T01SchoolDescriptionVC : UIViewController

- (void) setDescriptionText: (NSString*) text;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (nonatomic, weak) id delegate;

@end
