//
//  SWLoadingView.m
//  Joblet
//
//  Created by Sandy Wu on 11-04-09.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "SWLoadingView.h"

static SWLoadingView *sharedInstance;

@implementation SWLoadingView

@synthesize textLabel;

+ (SWLoadingView *)sharedInstance
{
	if (sharedInstance == nil)
	{
		NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SWLoadingView" owner:nil options:nil];
		sharedInstance = [[views objectAtIndex:0] retain];
		// TODO: Need to come back later and make this work for landscape as well.
		sharedInstance.frame = CGRectMake(0, 0, 320, 480);
	}
	return sharedInstance;
}

- (void)dealloc {
	[textLabel release], textLabel = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark SWLoadingView Class Methods

+ (void)show
{
	[[SWLoadingView class] performSelectorOnMainThread:@selector(showWithTextOnMainThread:) withObject:nil waitUntilDone:NO];
}

+ (void)showWithText:(NSString *)text
{
	[[SWLoadingView class] performSelectorOnMainThread:@selector(showWithTextOnMainThread:) withObject:text waitUntilDone:NO];
}

+ (void)showWithTextOnMainThread:(NSString *)text
{
	SWLoadingView *lView = [SWLoadingView sharedInstance];
	
	if (text == nil)
		lView.textLabel.text = kString_SW_Loading;
	else
		lView.textLabel.text = text;
	// TODO: find the keyboard window and draw the loading above the keyboard
	UIWindow *top = [[UIApplication sharedApplication] keyWindow];
	[top addSubview:lView];
	
}

+ (void)hide
{
	[[SWLoadingView class] performSelectorOnMainThread:@selector(hideOnMainThread) withObject:nil waitUntilDone:NO];
}

+ (void)hideOnMainThread
{
	[[SWLoadingView sharedInstance] removeFromSuperview];
}

@end
