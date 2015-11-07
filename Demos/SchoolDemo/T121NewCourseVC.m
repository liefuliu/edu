//
//  T121NewCourseVCTableViewController.m
//  SchoolDemo
//
//  Created by Liefu Liu on 11/1/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "T121NewCourseVC.h"
#import "SRXSingleSelectionTableViewController.h"

@interface T121NewCourseVC () 


@property SDCourse* course;

// Static properties
@property NSArray* rowTexts;
@property NSMutableArray* rowSubTexts;
@property NSArray* allProjects;


@end

@implementation T121NewCourseVC

const int projectRowIndex = 0;
const int introRowIndex = 1;
const int teacherRowIndex = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新开一门课程";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    [editButtonItem setTitle: @"完成"];
    self.navigationItem.rightBarButtonItem = editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _rowTexts = @[@"科目", @"课程简介", @"任课老师", @"上课时间", @"费用"];
    _rowSubTexts = [[NSMutableArray alloc] initWithArray:_rowTexts];
    for (int i = 0; i < [_rowSubTexts count]; ++i) {
        _rowSubTexts[i] = @"";
    }
    
    _allProjects = @[@"语文", @"数学", @"英语", @"钢琴", @"舞蹈", @"围棋", @"书法", @"美术"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TitleCell"];
    
    _course = [[SDCourse alloc] init];
}

- (void) doneAction: (id) sender {
    if ([self.delegate respondsToSelector:@selector(courseCreated:)]) {
        [self.delegate courseCreated:_course];
    }

    [self.navigationController popViewControllerAnimated:YES];
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
    return [_rowTexts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RichTextTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }

    
    // Configure the cell...
    cell.textLabel.text = (NSString*) [_rowTexts objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = (NSString*) [_rowSubTexts objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        if ([_course project]) {
            cell.detailTextLabel.text = [_course project];
        } else {
            //cell.detailTextLabel.text = @"未设置";
        }
    } else if (indexPath.row == 1){
        if ([[_course description] length] > 0) {
            //cell.detailTextLabel.text = @"已设置";
        } else {
            //cell.detailTextLabel.text = @"未设置";
        }
    } else if (indexPath.row == 2) {
        if ([_course teacher]) {
            cell.detailTextLabel.text = [[_course teacher] name];
        } else {
            //cell.detailTextLabel.text = @"未设置";
        }
    }
    
    if (indexPath.row > 0) {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            SRXSingleSelectionTableViewController* vc = [[SRXSingleSelectionTableViewController alloc] initWithItems:_allProjects];
            vc.delegate = self;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1){
            /*
            T12CourseListVC* vc = [[T12CourseListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];*/
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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

- (void) itemDidSelectAt: (int) selectedIndex
             withContent: (NSString*) selectedItem {
    [_course setProject:selectedItem];
    [self.tableView reloadData];
}


@end
