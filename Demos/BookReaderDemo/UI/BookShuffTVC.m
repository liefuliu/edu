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

/*
@property NSMutableArray* dailyBookKeys;
@property NSMutableArray* weeklyBookKeys;
@property NSMutableArray* historicalBookKeys;
*/

// Element: NSMutableArray
@property NSMutableArray* bookKeysArray;
@end

@implementation BookShuffTVC

const int kBookShuffTVCDailySection = 0;
const int kBookShuffTVCWeekySection = 1;
const int kBookShuffTVCHistoricalSection = 2;
const int kBookShuffTVCNumOfSections = 3;

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
    return kBookShuffTVCNumOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == kBookShuffTVCDailySection){
        return @"今天读过的书";
    } else if (section == kBookShuffTVCWeekySection) {
        return @"本周读过的书";
    } else if (section == kBookShuffTVCHistoricalSection) {
        return @"上周以前读过的书";
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < kBookShuffTVCNumOfSections) {
        return [self.bookKeysArray[section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < kBookShuffTVCNumOfSections) {
        BookItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BookItemCell"
                                                             forIndexPath:indexPath];
        
        NSString* bookKey = self.bookKeysArray[indexPath.section][indexPath.row];
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
    if (indexPath.section < kBookShuffTVCNumOfSections){
        BookPlayerScrollVC *detailViewController = [[BookPlayerScrollVC alloc] initWithBookKey:self.bookKeysArray[indexPath.section][indexPath.row]];
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
    
    self.bookKeysArray = [[NSMutableArray alloc] init];
    
    NSMutableArray* dailyBookKeys = [[NSMutableArray alloc] init];
    NSMutableArray* weeklyBookKeys = [[NSMutableArray alloc] init];
    NSMutableArray* historicalBookKeys =[[NSMutableArray alloc] init];
    
    NSDate* current = [NSDate date];
    for (NSString* bookKey in self.allBookKeys) {
        // LocalBookStatus* =
        BRDLocalBookStatus* localBookStatus =
            [[BRDBookShuff sharedObject] getBookStatus:bookKey];
        NSDate* lastReadDate = localBookStatus.lastReadDate;
        NSTimeInterval timeInterval = [current timeIntervalSinceDate:lastReadDate];
        
        const double secondsInADay = 60 * 60 * 24;
        const double secondsInAWeek = secondsInADay * 7;
        if (timeInterval < secondsInADay) {
            [dailyBookKeys addObject:bookKey];
        } else if (timeInterval < secondsInAWeek) {
            [weeklyBookKeys addObject:bookKey];
        } else {
            [historicalBookKeys addObject:bookKey];
        }
    }
    
    [self.bookKeysArray addObject:dailyBookKeys];
    [self.bookKeysArray addObject:weeklyBookKeys];
    [self.bookKeysArray addObject:historicalBookKeys];
    
    
    [self.tableView reloadData];
}

@end
