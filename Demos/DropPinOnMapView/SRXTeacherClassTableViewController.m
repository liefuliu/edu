//
//  SRXTeacherClassViewControllerTableViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 9/6/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXTeacherClassTableViewController.h"
#import "SRXTeacherClassCollection.h"
#import "SRXTeacherClassCell.h"
#import "SRXTeacherOpenClassViewController.h"
#import "SRXColor.h"
#import "SRXApiFactory.h"
#import "SRXClassUtil.h"

@interface SRXTeacherClassTableViewController ()

// An array of SRXDataClassInfo which are owned by the current user.
@property NSMutableArray* allClasses;
@property NSDictionary* classTypeDescriptionDictionary;

@end

@implementation SRXTeacherClassTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super viewDidLoad];
    
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
    
    [self performSelector:@selector(initializeData)];
    
    self.classTypeDescriptionDictionary = [SRXClassUtil getClassDescriptiveDictionary];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) newClassCreated {
    NSLog(@"newClassCreated");
    [self initializeData];
    [self.tableView reloadData];
}

#pragma mark - initialize data
- (void) initializeData {
    SRXDataUser* requestingUser = [[[SRXDataUser builder] setId:@"dummy"] build];
    
    SRXProtoReadClassRequest* request = [[[[SRXProtoReadClassRequest builder] setRequestingUser:requestingUser] setRoleInClass:SRXDataRoleInClassTypeEnumSRXDataRoleInClassTypeOwner] build];
    SRXProtoReadClassResponseBuilder *responseBuilder = [SRXProtoReadClassResponse builder];
    
    __block __weak SRXTeacherClassTableViewController *wself = self;
    
    [[SRXApiFactory getActualApi] readClass: request
                               withResponse:&responseBuilder completion:^(BOOL success, NSString* errorMsg) {
        if (success) {
            SRXProtoReadClassResponse* response = [responseBuilder build];
            self.allClasses = [response classCollection];
            NSLog(@"Successfully retrieved allClasses: %@", self.allClasses);
        } else {
            // DO nothing
            NSLog(@"Cannot read class");
        }
        
    }];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.sharedClassCollectionForDemo
    // Return the number of rows in the section.
    if (section == 1) {
        //return [[[SRXTeacherClassCollection sharedClassCollectionForDemo] classCollection] count];
        return [_allClasses count];
    } else if (section == 0) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 1 ) {
        SRXTeacherClassCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SRXTeacherClassCell" forIndexPath:indexPath];
        
        // Configure the cell...
        NSArray *items = self.allClasses;
        SRXDataClassInfo* classInfo = items[indexPath.row];
        /*
        // TODO(liefuliu): Currently we used hard code for demo purpose;
        classInfo.topic = @"钢琴";
        cell.topicLabel.text = [classInfo topic];
        cell.timeLabel.text = [classInfo time];
        */
        
        if (indexPath.row % 3) {
            cell.statusLabel.text = @"已开学";
        } else {
            cell.statusLabel.text = @"10月1日开学";
        }
        cell.timeLabel.text = @"每周四晚";
        cell.topicLabel.text = (NSString*)[self.classTypeDescriptionDictionary objectForKey:[NSNumber numberWithInt:classInfo.classType]];
        
        /*
        cell.timeLabel.text = [classInfo summary];
        cell.statusLabel.text = [classInfo summary];
        */
        
        NSLog(@"class info: %@", classInfo);
        return cell;
     } else if (indexPath.section == 0) {
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
         cell.textLabel.text = NSLocalizedString(@"Create a new class", @"Link of creating a new class");
         cell.textLabel.textColor = [SRXColor colorForTextLink];
         return cell;
     }
    
    return nil;
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
        SRXTeacherOpenClassViewController *detailViewController = [[SRXTeacherOpenClassViewController alloc] init];
        detailViewController.delegate = self;
        // Push it onto the top of the navigation controller's stack
        [self.navigationController pushViewController:detailViewController
                                             animated:YES];
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
