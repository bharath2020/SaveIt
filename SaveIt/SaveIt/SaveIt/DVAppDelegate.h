//
//  DVAppDelegate.h
//  SaveIt
//
//  Created by Bhagya on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVViewController;

@interface DVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DVViewController *viewController;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
