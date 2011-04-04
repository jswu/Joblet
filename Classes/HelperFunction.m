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
	[HelperFunction showAlertMsg:msg withTitle:NSLocalizedString(@"Error", "Error alert heading")];
}

+ (void)showAlertCheckConnection
{
	NSLog(@"z1");
	[HelperFunction showAlertMsg:NSLocalizedString(@"Please check that you are connected to the internet and try again.", @"No internet connection error message") withTitle:NSLocalizedString(@"Error", "Error alert heading")];
}

+ (void)showAlertMsg:(NSString *)msg withTitle:(NSString *)title
{
	NSLog(@"z2");
	[[HelperFunction class] performSelectorOnMainThread:@selector(showAlertMsgWithTitleOnMainThread:) 
											 withObject:[NSArray arrayWithObjects:msg, title, nil]
										  waitUntilDone:NO];
}

+ (void)showAlertMsgWithTitleOnMainThread:(NSArray *)params
{
	NSLog(@"z3");
	NSString *msg =		[params objectAtIndex:0];
	NSString *title =	[params objectAtIndex:1];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg 
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"OK", "Alert button option") 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
