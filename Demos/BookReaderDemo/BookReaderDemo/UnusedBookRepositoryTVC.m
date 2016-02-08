//
//  BookRepositoryTVC.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 1/22/16.
//  Copyright © 2016 SanRenXing. All rights reserved.
//

#import "UnusedBookRepositoryTVC.h"
#import "BRDBookLister.h"
#import "BRDBookSummary.h"
#import "BRDListedBook.h"
#import "BookItemCell.h"
#import "BookDownloadWaitVC.h"
#import "BookPlayerScrollVC.h"
#import "BRDBookShuff.h"

@interface UnusedBookRepositoryTVC ()
@end

@implementation UnusedBookRepositoryTVC

NSTimer* myTimer;
UIProgressView* myProgressView;
UIActivityIndicatorView *indicatorView;

NSArray* bookList;
NSDictionary* bookCoverImages;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*
    _bookLister = [[BookLister alloc] init];
    if (![_bookLister connectToServer]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法连接到服务器" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [_bookLister getListOfBooks:100 startFrom:0];
     */
    
    
    UINib *nib = [UINib nibWithNibName:@"BookItemCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"BookItemCell"];
    
    // bar.topItem.title = @"title text";
    self.title = @"书架";
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
    indicatorView = [self showSimpleActivityIndicatorOnView:self.view];
    
    [self tryLoadBookList];
    


}


- (void)updateUI:(NSTimer *)timer
{
    myProgressView.progress += 0.5;
    
    if ((int)myProgressView.progress) {
        [myTimer invalidate];
        NSLog(@"Progress complete");
        
        [indicatorView stopAnimating];
        /*
        Demoview*VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Demoview"];
        [self.navigationController pushViewController:VC animated:YES];*/
    }
    
}

- (UIActivityIndicatorView *)showSimpleActivityIndicatorOnView:(UIView*)aView
{
    CGSize viewSize = aView.bounds.size;
    
    // create new dialog box view and components
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityIndicatorView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    
    [aView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    return activityIndicatorView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [bookList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0 ) {
        BookItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BookItemCell"
                                                             forIndexPath:indexPath];
        
        BRDListedBook* bookInfo = [bookList objectAtIndex:indexPath.row];
        
        cell.statusLabel.text = bookInfo.author;
        cell.topicLabel.text = bookInfo.bookName;
        BRDBookSummary* bookSummary = (BRDBookSummary*)[bookCoverImages objectForKey:bookInfo.bookId];
        
        if (bookSummary) {
            cell.imageView.image = [[UIImage alloc] initWithData: bookSummary.imageData];
        }
        
        
        return cell;
    } else {
        return nil;
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        BRDListedBook* bookInfo = [bookList objectAtIndex:indexPath.row];
        
        if ([[BRDBookShuff sharedObject] doesBookExist:[bookInfo bookId]]) {
            BookPlayerScrollVC *detailViewController = [[BookPlayerScrollVC alloc] initWithBookKey:bookInfo.bookId];
            [self.navigationController presentViewController:detailViewController animated:YES completion:nil];

        } else {
            BookDownloadWaitVC* waitingVC = [[BookDownloadWaitVC alloc] initWithBookKey:[bookInfo bookId]];
            waitingVC.delegate = self;
            [self.navigationController presentViewController:waitingVC animated:nil completion:nil];
        }
    }
}


- (void) downloadComplete: (NSString*) bookKey {
    [[BRDBookShuff sharedObject] addBook:nil forKey:bookKey];
   BookPlayerScrollVC *detailViewController = [[BookPlayerScrollVC alloc] initWithBookKey:bookKey];
   [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
}

/* http://stackoverflow.com/questions/5404856/how-to-disable-touch-input-to-all-views-except-the-top-most-view
 Hope this help...
 
 [[yourSuperView subviews]
 makeObjectsPerformSelector:@selector(setUserInteractionEnabled:)
 withObject:[NSNumber numberWithBool:FALSE]];
 which will disable userInteraction of a view's immediate subviews..Then give userInteraction to the only view you wanted
 
 yourTouchableView.setUserInteraction = TRUE;
 
 */


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

#pragma logic layer

-(void) tryLoadBookList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        
        BRDBookLister* bookLister = [[BRDBookLister alloc] init];
        if (![bookLister connectToServer]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法连接到服务器" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        __block NSArray* arrayOfBooks;
        
        [bookLister getListOfBooks:100 startFrom:0 to:&arrayOfBooks];
        for (NSString* bookName in arrayOfBooks) {
            NSLog(@"book name:%@", bookName);
        }
        
        //we get the main thread because drawing must be done in the main thread always
        dispatch_async(dispatch_get_main_queue(),^ {
            // [cell.imageView setImage:cellImage];
            bookList = arrayOfBooks;
            [indicatorView stopAnimating];
            
            [self.tableView reloadData];
            [self tryLoadBookImages];
        } );
        
    });
}

- (void) tryLoadBookImages {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
        BRDBookLister* bookLister = [[BRDBookLister alloc] init];
        __block NSDictionary* bookSummaryInfo;
        
        NSMutableArray* arrayOfBookId = [[NSMutableArray alloc] init];
        for (BRDListedBook* book in bookList) {
            [arrayOfBookId addObject:book.bookId];
        }
        
        [bookLister getSummaryInfoForBooks:arrayOfBookId to:&bookSummaryInfo];
        /*
        for (NSString* bookName in arrayOfBooks) {
            NSLog(@"book name:%@", bookName);
          }*/
        
        //we get the main thread because drawing must be done in the main thread always
        dispatch_async(dispatch_get_main_queue(),^ {
            // [cell.imageView setImage:cellImage];
            bookCoverImages = bookSummaryInfo;
            
            [self.tableView reloadData];
        } );
        
    });
}

@end
