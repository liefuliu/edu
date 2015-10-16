//
//  SRXStudentClassViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 10/3/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXStudentClassViewController.h"
#import "SRXProtocols.h"
#import "SRXApiFactory.h"
#import "SRXDataImage.pb.h"
#import "SRXImageViewController.h"

@interface SRXStudentClassViewController ()

@property NSMutableArray* imagesOfClass;

@end

@implementation SRXStudentClassViewController

// 'classInfo' must be set (in initialization function) before loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    NSLog(@"Class Info in student class view: %@", _classInfo);
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(clickEventOnImage:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [tapRecognizer setDelegate:self];
    
    self.imageViewAtTop.userInteractionEnabled = YES;
    [self.imageViewAtTop addGestureRecognizer:tapRecognizer];
    
    [self loadImagesAsync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadImagesAsync {
    // Get images.
    SRXProtoGetImagesRequestBuilder* imagesRequestBuilder = [SRXProtoGetImagesRequest builder];
    
    for(SRXDataImageRef* imageRef in [self.classInfo imageRef]) {
        // TODO: add the server type filter.
        [imagesRequestBuilder addImageKey:[imageRef imageKey]];
    }
    
    SRXProtoGetImagesRequest* imagesRequest = [imagesRequestBuilder build];
    SRXProtoGetImagesResponseBuilder* responseBuilder = [SRXProtoGetImagesResponse builder];
    
    [[SRXApiFactory getActualApi] getImages:imagesRequest withResponse:&responseBuilder completion:^(BOOL success, NSString* error) {
        if (success) {
            // Load images.
            _imagesOfClass = [[NSMutableArray alloc] init];
            SRXProtoGetImagesResponse* response = [responseBuilder build];
            for (SRXDataImage* imageData in response.imageData) {
                UIImage* image = [UIImage imageWithData: [imageData data]];
                [_imagesOfClass addObject:image];
            }
            
            // Display the first image view
            if ([_imagesOfClass count] > 0) {
                self.imageViewAtTop.image = _imagesOfClass[0];
            }
        } else {
            // TODO(liefuliu) display the alert: "cannot load image".
        }
    }];
}


-(void) clickEventOnImage:(UITapGestureRecognizer*) recognizer {
    SRXImageViewController* imageViewController = [[SRXImageViewController alloc] initWithImageArray: _imagesOfClass];
    
    [self.navigationController pushViewController:imageViewController animated:YES];
    
}

#pragma mark - Table view data source


/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}*/

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
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


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}


@end
