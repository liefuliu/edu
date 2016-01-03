//
//  BookTableVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/20/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "BookTableVC.h"
#import "BookItemCell.h"
#import "RootViewController.h"

#import "LocalBookStore.h"

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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int numRows =[[[LocalBookStore sharedObject] allBookKeys] count];
    return numRows;
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
        
        NSString* bookKey = (NSString*)[[LocalBookStore sharedObject] allBookKeys][indexPath.row];
        
        LocalBook* bookInfo = [[LocalBookStore sharedObject] getBookWithKey:bookKey];
        
        cell.statusLabel.text = bookInfo.author;
        cell.topicLabel.text = bookInfo.bookName;
        
        NSString* imageFilePath = [NSString stringWithFormat:@"%@/%@-picture-0001.jpg",
                                   [[NSBundle mainBundle] resourcePath],
                                   bookInfo.filePrefix];
        cell.bookImage.image = [UIImage imageWithContentsOfFile:imageFilePath];

        
        return cell;
    } else {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        NSString* bookKey = (NSString*)[[LocalBookStore sharedObject] allBookKeys][indexPath.row];

        RootViewController *detailViewController = [[RootViewController alloc] initWithBookKey:bookKey];
        [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"didDismissWithButtonIndex called here");
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
