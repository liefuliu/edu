//
//  T1SchoolOverviewVC.m
//  SchoolDemo
//
//  Created by Liefu Liu on 10/30/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "T1SchoolOverviewVC.h"

#import "T11SchoolInfoVC.h"
#import "SRXTeacherClassTableViewController.h"

@interface T1SchoolOverviewVC ()

@property NSArray* options;

@end

@implementation T1SchoolOverviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = NSLocalizedString(@"School", nil);

    _options = [[NSMutableArray alloc] initWithArray:@[
                                                       NSLocalizedString(@"School Profile", @"Profile"),  //
                                                       NSLocalizedString(@"Classes Management", @"Classes"),  //
                                                       NSLocalizedString(@"Teacher Info", "Teachers"),  //
                                                       NSLocalizedString(@"Student Info", "Students")  // 学生资料
                                                      /*
                                                      NSLocalizedString(@"Updates", nil)
                                                      NSLocalizedString(@"Switch to another school", nil),
                                                       */
                                                ]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TitleCell"];
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
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = (NSString*) [_options objectAtIndex:indexPath.row];
        if (indexPath.row >= 2) {
            cell.textLabel.textColor = [UIColor grayColor];
        }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    }
    
    
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            T11SchoolInfoVC* vc = [[T11SchoolInfoVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1){
            SRXTeacherClassTableViewController* vc = [[SRXTeacherClassTableViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
