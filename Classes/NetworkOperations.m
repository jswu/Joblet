//
//  NetworkOperations.m
//  Joblet
//
//  Created by Sandy Wu on 11-05-16.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "NetworkOperations.h"
#import "Reachability.h"
#import "SWLoadingView.h"


@implementation NetworkOperations

+ (BOOL)hasNetworkConnection
{
	return (![[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable);
}

+ (void)resetJobMineTimeout
{
    [[NetworkOperations class] performSelectorInBackground:@selector(resetJobMineTimeoutOnBackgroundThread) withObject:nil];
}

+ (void)resetJobMineTimeoutOnBackgroundThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ASIHTTPRequest *resetTimeoutRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:kJobMineURL_ResetTimeout]];
    [resetTimeoutRequest startSynchronous];
    
    NSString *response = [[[resetTimeoutRequest responseString] stringAfterTrim] copy];
    // TODO: Show ans  "Expires in *TIME*" timer in the UI? Have the timer reset here
    if ([response isEqualToString:kJobMineStrings_ResetTimeoutSuccess]) 
        NSLog(@"Reset timeout succeeded");
    else
        NSLog(@"Reset timeout failed");
    
    [response release];
    [resetTimeoutRequest release];
    
    [pool drain];
}

+ (void)requestToLoginWithUserID:(NSString *)userID password:(NSString *)password callback:(SEL)method on:(id)target
{
	NSArray *params = [[NSArray alloc] initWithObjects:userID, password, NSStringFromSelector(method), target, nil];
	
	[[NetworkOperations class] performSelectorInBackground:@selector(requestToLoginWithUserIDOnBackgroundThread:) withObject:params];
	/* run the following in a background thread, synchronously
	NSString *stringForURL = [[NSString alloc] initWithFormat:kJobMineURL_LoginForm];
	NSURL *URL = [[NSURL alloc] initWithString:stringForURL];
	loginRequest = [[ASIFormDataRequest alloc] initWithURL:URL];
	[loginRequest setPostValue:[NSNumber numberWithInteger:300] forKey:@"timezoneOffset"];
	[loginRequest setPostValue:userID forKey:@"userid"];
	[loginRequest setPostValue:password forKey:@"pwd"];
	[loginRequest setPostValue:@"Submit" forKey:@"submit"];
	[loginRequest setDelegate:[NetworkOperations class]];
	
	[stringForURL release];
	[URL release];
	
	//[loginRequest startAsynchronous];
	 */
}

+ (void)requestToLoginWithUserIDOnBackgroundThread:(NSArray *)params
{
	/*
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *userID = [params objectAtIndex:0];
	NSString *password = [params objectAtIndex:1];
	SEL method = NSSelectorFromString([params objectAtIndex:2]);
	id target = [params objectAtIndex:3];
	
	NSString *stringForURL = [[NSString alloc] initWithFormat:kJobMineURL_LoginForm];
	NSURL *URL = [[NSURL alloc] initWithString:stringForURL];
	ASIFormDataRequest *loginRequest = [[ASIFormDataRequest alloc] initWithURL:URL];
	[loginRequest setPostValue:[NSNumber numberWithInteger:300] forKey:@"timezoneOffset"];
	[loginRequest setPostValue:userID forKey:@"userid"];
	[loginRequest setPostValue:password forKey:@"pwd"];
	[loginRequest setPostValue:@"Submit" forKey:@"submit"];
	[loginRequest setDelegate:[NetworkOperations class]];
	
	[stringForURL release];
	[URL release];
	[params release];
	
	[loginRequest startSynchronous];
	
	NSString *response = [[loginRequest responseString] copy];
	[target performSelector:method withObject:response]; // Remember to release response
	[loginRequest release];
     
    [pool drain];
	*/
}

+ (void)requestToApplicationsWithCallback:(SEL)method on:(id)target
{
	
}

+ (void)requestToApplicationsWithCallbackOnBackgroundThread:(NSArray *)params
{
	
}

/*
 + (void)requestToShortListWithCallBack:(SEL)method on:(id)target
 {
 
 }
 
 + (void)requestToInterviewsWithCallback:(SEL)method on:(id)target
 {
 
 }
 */

@end
