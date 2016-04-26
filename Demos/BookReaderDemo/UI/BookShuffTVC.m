//
//  BookShuffTVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 2/5/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "BRDBookShuff.h"
#import "BRDBookSummary.h"
#import "BRDFileUtil.h"
#import "BookItemCell.h"
#import "BookShuffTVC.h"
#import "BookPlayerScrollVC.h"
#import "LocalBook.h"

@interface BookShuffTVC ()

// An array of NSString* objects.
@property NSArray* allBookKeys;

@end

@implementation BookShuffTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib = [UINib nibWithNibName:@"BookItemCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"BookItemCell"];
    self.title = @"书架";
    
    //[self loadBooksOnShuff];
}

- (void) viewWillAppear:(BOOL)animated {
    [self loadBooksOnShuff];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// TODO(liefuliu):
// Consider to increase number of sections to categorize the books on shuff.
// For example, Section 0 contains most recently viewed books, and Section 1 contains
// less recently reviewed ones.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return @"今天读过的书";
    } else if (section == 1) {
        return @"本周读过的书";
    } else if (section == 2) {
        return @"上周以前读过的书";
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.allBookKeys count];
    } else if (section == 1) {
        return [self.allBookKeys count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0 || indexPath.section == 1) {
        BookItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BookItemCell"
                                                             forIndexPath:indexPath];
        
        NSString* bookKey = self.allBookKeys[indexPath.row];
        LocalBook* bookInfo = [[BRDBookShuff sharedObject] getBook:bookKey];
        
        cell.statusLabel.text = bookInfo.author;
        cell.topicLabel.text = bookInfo.bookName;
        
        NSData* imageData = [BRDFileUtil getBookCoverImage:bookKey];
            cell.imageView.image = [[UIImage alloc] initWithData:imageData];
        
        return cell;
    } else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        BookPlayerScrollVC *detailViewController = [[BookPlayerScrollVC alloc] initWithBookKey:self.allBookKeys[indexPath.row]];
        [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
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

#pragma mark - Data processing
- (void) loadBooksOnShuff {
    self.allBookKeys = [[BRDBookShuff sharedObject] getAllBookKeys];
    [self.tableView reloadData];
}

@end
