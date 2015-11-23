//
//  T12CourseListVC.m
//  SchoolDemo
//
//  Created by Liefu Liu on 11/1/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "T12CourseListVC.h"
#import "T121NewCourseVC.h"
#import "SRXTeacherClassCell.h"
#import "SDCourse.h"

@interface T12CourseListVC () <T121NewCourseVCDelegate>

@property NSMutableArray* allCourses;

@end

@implementation T12CourseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.title = @"课程管理";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // This table view will contain 2 sections. The section 0 is for the class list, and the section 1 is to
    // open a class.
    //
    // Register this NIB, which contains the cell for Section 0.
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"SRXTeacherClassCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"SRXTeacherClassCell"];
    
    //[self.tableView registerClass:[SRXTeacherClassCell class] forCellReuseIdentifier:@"SRXTeacherClassCell"];
    
    // Use the default cell for Section 1.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    _allCourses = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self.allCourses count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section== 1 ) {
        SRXTeacherClassCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SRXTeacherClassCell"
                                                                    forIndexPath:indexPath];
        
        // Configure the cell...
        NSArray *items = self.allCourses;
        SDCourse* course = items[indexPath.row];
        
        // TODO(liefuliu): Currently we hard coded time label and status label for demo
        // purpose. Set it properly when these info are essentially stored in 'classInfo'.
        if (indexPath.row % 3) {
            cell.statusLabel.text = @"已开学";
        } else {
            cell.statusLabel.text = @"11月1日开学";
        }
        cell.timeLabel.text = @"每周四晚";
        cell.topicLabel.text = course.project;
        
        return cell;
    } else if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = @"新开一门课程";
        cell.textLabel.textColor = [UIColor blueColor];
        return cell;
    }
    
    return nil;
    
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            T121NewCourseVC* vc = [[T121NewCourseVC alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1){
            
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

#pragma delegates

- (void) courseCreated: (SDCourse*) course {
    [_allCourses addObject:course];
    [self.tableView reloadData];
}

@end
