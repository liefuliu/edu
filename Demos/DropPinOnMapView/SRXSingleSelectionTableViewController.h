//
//  SRXSingleSelectionTableViewController.h
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/27/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRXSingleSelectionTableViewControllerDelegate
- (void) itemDidSelectAt: (int) selectedIndex
            withContent: (NSString*) selectedItem;
@end

@interface SRXSingleSelectionTableViewController : UITableViewController

// Must be an array of NSString.
@property (nonatomic, readonly) NSArray* itemsForSelection;

- (instancetype) initWithItems: (NSArray*) itemsForSelection;

- (instancetype) initWithTitle: (NSString*) title
                         Items: (NSArray*) itemsForSelection;


@property (nonatomic, weak) id delegate;

@end
