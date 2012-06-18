//
//  DVAppDelegate.m
//  SaveIt
//
//  Created by Bhagya on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVAppDelegate.h"

#import "DVViewController.h"
#import "DVCardsViewcontroller.h"
#import "DVCategoryListViewController.h"
#import "DVUtilities.h"

@implementation DVAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //move the icons directory
    [DVUtilities moveIconsDirectory];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //create a tab bar
    DVCardsViewController *cardsViewController = [[DVCardsViewController alloc] initWithNibName:@"DVCardsViewController" bundle:nil];
    UINavigationController *cardsNavController = [[UINavigationController alloc] initWithRootViewController:cardsViewController];

    
    DVCategoryListViewController *categoryListViewController = [[DVCategoryListViewController alloc] initWithNibName:@"DVCategoryListViewController" bundle:nil];
    UINavigationController *categoryNavController = [[UINavigationController alloc] initWithRootViewController:categoryListViewController];
    categoryNavController.navigationBar.tintColor = [UIColor colorWithRed:140/255.0 green:58.0f/255.0f blue:12.0/255.0f alpha:1.0];

    
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:cardsNavController,categoryNavController, nil]];
    
    
    // Override point for customization after application launch.
    //self.viewController = self.tabBarController;
//    self.viewController = [[DVViewController alloc] initWithNibName:@"DVViewController" bundle:nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
