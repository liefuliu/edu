//
//  T11SchoolInfoVC.m
//  SchoolDemo
//
//  Created by Liefu Liu on 10/31/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "T11SchoolInfoVC.h"
#import "T111SchoolEditorVC.h"
#import "ImageTableCell.h"
#import "MapTableCell.h"
#import <CoreLocation/CoreLocation.h>

@interface T11SchoolInfoVC ()

@end

@implementation T11SchoolInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"学校信息";
    
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    
    [editButtonItem setTitle: @"修改"];
    self.navigationItem.rightBarButtonItem = editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[ImageTableCell class] forCellReuseIdentifier:@"ImageTableCell"];
    //[self.tableView registerClass:[ImageTableCell class] forCellReuseIdentifier:@"PlainTextTableCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)editAction:(id)sender
{
    T111SchoolEditorVC* editVC = [[T111SchoolEditorVC alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"ImageTableCell";

        ImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.imageView.image = [UIImage imageNamed:@"img_sdfz2.jpeg" ];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"PlainTextTableCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"学校名称";
        cell.detailTextLabel.text = @"湖南师大附中";
        return cell;

    } else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"RichTextTableCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"学校简介";
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.numberOfLines = 5;

        cell.detailTextLabel.text = @"湖南师范大学附属中学（The High School Attached To Hunan Normal University）是湖南省教育厅直属公办高级中学（保留完全中学建制）、湖南省首批八所重点中学，也是湖南省示范性普通高级中学。";
        return cell;
    } else if (indexPath.section == 3) {
        /*
        static NSString *CellIdentifier = @"MapTableCell";
        
        MapTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MapTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
        }
        return cell;*/
        
        static NSString *CustomCellIdentifier = @"MapTableCell";
        MapTableCell *cell = (MapTableCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MapTableCell"
                                                         owner:self options:nil];
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[MapTableCell class]])
                    cell = (MapTableCell *)oneObject;
        }
        
        
        
        MKMapView *mapView = cell.mapView; //(MKMapView*)[cell viewWithTag:2];
        
        //Takes a center point and a span in miles (converted from meters using above method)
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(37.766997, -122.422032);
        MKCoordinateRegion adjustedRegion = [mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 1000, 1000)];
        [mapView setRegion:adjustedRegion animated:YES];
        //[mapView addAnnotation:]
        return cell;
    }
    
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    } else if (indexPath.section == 2) {
        return 120;
    } else if (indexPath.section == 3) {
        return 300;
    }
    
    return 50;
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
