//
//  HelperFunction.m
//  Joblet
//
//  Created by Sandy Wu on 11-04-03.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "HelperFunction.h"


@implementation HelperFunction

+ (void)showErrorAlertMsg:(NSString *)msg
{
	[HelperFunction showAlertMsg:msg withTitle:kString_Error];
}

+ (void)showAlertCheckConnection
{
	[HelperFunction showAlertMsg:kString_CheckInternetConnection withTitle:kString_Error];
}

+ (void)showAlertMsg:(NSString *)msg withTitle:(NSString *)title
{
	[[HelperFunction class] performSelectorOnMainThread:@selector(showAlertMsgWithTitleOnMainThread:) 
											 withObject:[NSArray arrayWithObjects:msg, title, nil]
										  waitUntilDone:NO];
}

+ (void)showAlertMsgWithTitleOnMainThread:(NSArray *)params
{
	NSString *msg =		[params objectAtIndex:0];
	NSString *title =	[params objectAtIndex:1];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg 
												   delegate:nil
										  cancelButtonTitle:kString_OK 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
