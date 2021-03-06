//
//  JobletAppDelegate.m
//  Joblet
//
//  Created by Sandy Wu on 11-01-10.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "JobletAppDelegate.h"
#import "JobletViewController.h"
#import "UserJobDatabase.h"

@implementation JobletAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[UserJobDatabase initDatabase];
	
	// Configure default user-defaults on first app launch.
	if (![[NSUserDefaults standardUserDefaults] boolForKey:kKeyDefaultOptionsSetForRelease1])
	{
		// Turn on job title and employer by default
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%d", kKeyOptions_ShowInfo, kOptionsViewTableCellRowIndex_ShowJobTitle]];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_%d", kKeyOptions_ShowInfo, kOptionsViewTableCellRowIndex_ShowEmployer]];
        // Sort by ascending application status by default
		[[NSUserDefaults standardUserDefaults] setObject:@"appStatusCode" forKey:kOptions_SortCriteriaKey];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kOptions_SortAscending];
        // Ensure the defaults are only set once per version
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKeyDefaultOptionsSetForRelease1];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	// Present the login screen
	JobletViewController *rootController = [[JobletViewController alloc] init];
    navigationController = [[UINavigationController alloc]
							initWithRootViewController:rootController];
    [rootController release];
	
	[navigationController setTitle:@"Login"];
//	self.navigationController.title = @"Login";
	
    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [navigationController release];
    [window release];
    [super dealloc];
}


@end
