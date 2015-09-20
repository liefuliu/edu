//
//  AppDelegate.m
//  DropPinOnMapView
//
//  Created by Liefu Liu on 8/2/15.

#import "AppDelegate.h"
#import <Parse/Parse.h>
// Test only. remove and switch back to main.storyboard.
#import "SRXTeacherOpenClassViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MapViewController *mvc = [[MapViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mvc];
    
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
     */
    
    // Add the Parse support.
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"v9dWkNcnBpIqIvramHo8CqAUts18toQJ1d9MTMNH"
                  clientKey:@"mwV3UjHfcFfSohPbjYk9QKt567OyJm6701TRSQmf"];
    
    BOOL testTeacherView = NO;
    if (testTeacherView) {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Create a BNRItemsViewController
    SRXTeacherOpenClassViewController *itemsViewController = [[SRXTeacherOpenClassViewController alloc] init];
    
    // Create an instance of a UINavigationController
    // its stack contains only itemsViewController
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
    
    // Place navigation controller's view in the window hierarchy
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
