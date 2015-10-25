//
//  SRXStudentListViewController.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 10/24/15.
//  Copyright (c) 2015 Liefu Liu. All rights reserved.
//

#import "SRXStudentListViewController.h"
#import "SRXSingleSelectionTableViewController.h"
#import "SRXClassUtil.h"
#import "UIViewController+Charleene.h"

@interface SRXStudentListViewController ()


// All classes type which allow user to choose in SRXSingleSelectionViewController.
// All elements are in type of SRXDataClassTypeEnumSRXDataClassType.
@property (nonatomic) NSArray* classTypesAllowToSelect;

// Strings of all classes type which allow user to choose in SRXSingleSelectionViewController.
// All elements are in type of NSString*.
@property (nonatomic) NSArray* classTypeStringsAllowToSelect;

@end

@implementation SRXStudentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"SRXStudentMapViewController viewDidLoad started");
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.searchBar;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Course" , nil) style:UIBarButtonItemStyleBordered target:self action:@selector(courseBarButtonPressed:)];
    
    [self initializeClassTypeItemsForSeletion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) initializeClassTypeItemsForSeletion {
    NSDictionary* dictionary = [SRXClassUtil getClassDescriptiveDictionary];
    self.classTypesAllowToSelect = [dictionary allKeys];
    self.classTypeStringsAllowToSelect = [dictionary allValues];
}


-(void) courseBarButtonPressed:(id)sender {
    
    SRXSingleSelectionTableViewController* selectionViewController = [[SRXSingleSelectionTableViewController alloc] initWithItems:self.classTypeStringsAllowToSelect];
    
    selectionViewController.delegate = self;
    selectionViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    selectionViewController.modalPresentationStyle =  UIModalPresentationFormSheet;
    
    CGPoint frameSize = CGPointMake([[UIScreen mainScreen] bounds].size.width*0.45f, [[UIScreen mainScreen] bounds].size.height*0.45f);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // Resizing for iOS 8
    selectionViewController.preferredContentSize = CGSizeMake(frameSize.x, frameSize.y);
    // Resizing for <= iOS 7
    selectionViewController.view.superview.frame = CGRectMake((screenWidth - frameSize.x)/2, (screenHeight - frameSize.y)/2, frameSize.x, frameSize.y);
    
    /*
     UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
     [vc presentViewController:selectionViewController animated:YES completion:nil];
     */
    
    [self presentCharleeneModally:selectionViewController transitionMode:KSModalTransitionModeFromRight];
}

# pragma SRXSingleSelectionTableViewControllerDelegate methods.

- (void) itemDidSelectAt: (int) selectedIndex
             withContent: (NSString*) selectedItem {
    NSLog(@"SelectedItem: %@", selectedItem);
    
    [self.navigationItem.rightBarButtonItem setTitle: selectedItem];
    
    // Reload the map
    
}


@end
