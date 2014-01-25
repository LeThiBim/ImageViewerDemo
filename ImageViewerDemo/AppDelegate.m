//
//  AppDelegate.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/19/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import "AppDelegate.h"
#import "ListAlbumsSource.h"
#import "ListAlbumsController.h"
#import "MFSideMenuContainerViewController.h"
#import "SideMenuViewController.h"
#import "SDImageCache.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    _currentMainScreenIndex = 0;
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)self.window.rootViewController;
    

    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];

     ListAlbumsController *listAlbumsController = (ListAlbumsController *)[storyboard instantiateViewControllerWithIdentifier:@"ListAlbumsController"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:listAlbumsController];

    [listAlbumsController setUpCustomLayOut];

    listAlbumsController.listAlbumsSource = [[ListAlbumsSource alloc] init];

    listAlbumsController.listAlbumsSource.delegate = listAlbumsController;
    [listAlbumsController.listAlbumsSource getImageLinksFromServerAtPage:0];

    navigationController.navigationBar.barStyle = UIBarStyleBlack;


    [self.window makeKeyAndVisible];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        [listAlbumsController setWantsFullScreenLayout:YES];
    }
    else
    {
        navigationController.navigationBar.translucent = YES;
    }

    
    
    //Master TableViewController (SideMenuViewController)
    SideMenuViewController* sideMenuViewController = (SideMenuViewController*) [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    
    
    [container setCenterViewController:navigationController];
    [container setLeftMenuViewController:sideMenuViewController];
    
    

    
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    //call to clear all cached memory image
    [[SDImageCache sharedImageCache] clearMemory];
    
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
@end
