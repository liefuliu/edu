//
//  BookTableVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "BookTableVC.h"
#import "BookItemCell.h"
#import "BookPlayerVC.h"

@interface BookTableVC ()

@end

@implementation BookTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Register this NIB, which contains the cell for Section 0.
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"BookItemCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"BookItemCell"];
    
    // bar.topItem.title = @"title text";
    self.title = @"请选择绘本";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    return 100;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0 ) {
        BookItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BookItemCell"
                                                                    forIndexPath:indexPath];
        
        cell.statusLabel.text = @"Synd Hoff";
        
        cell.topicLabel.text = @"Stanley";
        
        NSString* imageFilePath = [NSString stringWithFormat:@"%@/img-Z14160447-0001.jpg",
                                   [[NSBundle mainBundle] resourcePath]];
        cell.bookImage.image = [UIImage imageWithContentsOfFile:imageFilePath];

        
        return cell;
    } else {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
     
     NSArray *items = [[BNRItemStore sharedStore] allItems];
     BNRItem *selectedItem = items[indexPath.row];
     
     // Give detail view controller a pointer to the item object in row
     detailViewController.item = selectedItem;
     
     // Push it onto the top of the navigation controller's stack
     [self.navigationController pushViewController:detailViewController
     animated:YES];
     */
    
    if (indexPath.section == 0){
        BookPlayerVC *detailViewController = [[BookPlayerVC alloc] init];
        [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
    } else if (indexPath.section == 1) {
        // TODO (fengyi): Response to the event the class item was selected.
        // If a teacher (or school admin) selected the class item, a view with class
        // preview should be popped up.
        // We probably could push a view similar to SRXStudentClassViewController.
        //
        // Note: reuse it might be a bad idea, since we try our effort to make student
        // views and teacher viewers loosely coupled.
        
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
