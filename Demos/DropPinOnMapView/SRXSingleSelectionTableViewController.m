//
//  SRXSingleSelectionTableViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/27/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXSingleSelectionTableViewController.h"
#import "UIViewController+Charleene.h"

@implementation SRXSingleSelectionTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(50,10,50,10)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (instancetype) initWithItems: (NSArray*) itemsForSelection {
    self = [super init];
    if (self) {
        _itemsForSelection = itemsForSelection;
    }
    return self;
}


#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Please select", nil);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsForSelection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = (NSString*)self.itemsForSelection[indexPath.row];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSLog(@"indexPath.section == 0");
        if ([self.delegate respondsToSelector:@selector(itemDidSelectAt:withContent:)]) {
            [self.delegate itemDidSelectAt: (int)indexPath.row
                           withContent: self.itemsForSelection[indexPath.row]];
        }
    }
    // [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissCharleeneAnimated:YES completion:nil];
}


@end
