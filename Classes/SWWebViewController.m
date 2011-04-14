//
//  SWWebViewController.m
//  Joblet
//
//  Created by Sandy Wu on 11-04-05.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "SWWebViewController.h"


@implementation SWWebViewController

@synthesize delegate;
@synthesize webView;
@synthesize targetURL;
@synthesize allowRequest;

- (id)initWithStringURL:(NSString *)urlString andDelegate:(id<SWWebViewControllerDelegate>)assignDelegate
{
	if (self = [super init])
	{
		NSURL *tempURL = [[NSURL alloc] initWithString:urlString];
		self = [self initWithURL:tempURL andDelegate:assignDelegate];
		[tempURL release];
	}
	return self;
}

- (id)initWithURL:(NSURL *)url andDelegate:(id<SWWebViewControllerDelegate>)assignDelegate
{
	if (self = [super init])
	{
		self.targetURL = url;
		self.delegate = assignDelegate;
		self.allowRequest = YES;
		
		self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
		[self.webView release];
		self.webView.delegate = self;
		self.webView.scalesPageToFit = YES;
		[self.view addSubview:self.webView];
	}
	return self;
}

- (void)makeRequest
{
	NSURLRequest *tempRequest = [[NSURLRequest alloc] initWithURL:self.targetURL];
	[self.webView loadRequest:tempRequest];
	[tempRequest release];
}

- (void)adjustWebViewFrameToOrientation:(UIInterfaceOrientation)curInterfaceOrientation
{
	// Assumes a status bar and a navigation bar.
	// TODO: Should probably detect what shown, or find a way to fill the full view.
	if (UIInterfaceOrientationIsLandscape(curInterfaceOrientation))
		self.webView.frame = CGRectMake(0, 0, 480, 256);
	else
		self.webView.frame = CGRectMake(0, 0, 320, 416);
}

- (void)viewDidLoad
{
	[super viewDidLoad];
 
	[self adjustWebViewFrameToOrientation:self.interfaceOrientation];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self adjustWebViewFrameToOrientation:toInterfaceOrientation];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark UIWebView Delegate Methods

- (BOOL)webView:(UIWebView *)myWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return allowRequest;
}

- (void)webView:(UIWebView *)myWebView didFailLoadWithError:(NSError *)error
{
	self.allowRequest = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
	if ([delegate respondsToSelector:@selector(requestDidFailLoadForWebView:withError:)])
		[delegate requestDidFailLoadForWebView:myWebView withError:error];
}

- (void)webViewDidStartLoad:(UIWebView *)myWebView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)myWebView
{
	self.allowRequest = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if ([delegate respondsToSelector:@selector(requestDidFinishLoadForWebView:)])
		[delegate requestDidFinishLoadForWebView:myWebView];
}

- (void)dealloc {
	[webView release], webView = nil;
	[targetURL release], targetURL = nil;
	
    [super dealloc];
}


@end
