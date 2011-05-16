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

// For now, just have a separate request object for each request. There are not that many anyway.
static ASIFormDataRequest *loginRequest;
//static ASIFormDataRequest *applicationRequest;

+ (BOOL)hasNetworkConnection
{
	return (![[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable);
}

+ (void)requestToLoginWithUserID:(NSString *)userID password:(NSString *)password callback:(SEL)method on:(id)target
{
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

+ (void)requestToApplicationsWithCallback:(SEL)method on:(id)target
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
