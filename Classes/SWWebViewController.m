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

- (id)initWithStringURL:(NSString *)urlString andDelegate:(id<SWWebViewControllerDelegate>)assignDelegate
{
	
	if (self = [super init])
	{
		NSURL *tempURL = [[NSURL alloc] initWithString:urlString];
		self.targetURL = tempURL;
		[tempURL release];
		self.delegate = assignDelegate;
	}
	return self;
}

- (id)initWithURL:(NSURL *)url andDelegate:(id<SWWebViewControllerDelegate>)assignDelegate
{
	if (self = [super init])
	{
		self.targetURL = url;
		self.delegate = assignDelegate;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.webView release];
	self.webView.delegate = self;
	self.webView.scalesPageToFit = YES;
	[self.view addSubview:self.webView];
	
	NSURLRequest *tempRequest = [[NSURLRequest alloc] initWithURL:self.targetURL];
	[self.webView loadRequest:tempRequest];
	[tempRequest release];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	// TODO: This doens't quite work...There is just a black blob, need to fix this.
	self.webView.frame = [[UIScreen mainScreen] bounds];
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
	return YES;
}

- (void)webView:(UIWebView *)myWebView didFailLoadWithError:(NSError *)error
{
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
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)dealloc {
	[webView release], webView = nil;
	[targetURL release], targetURL = nil;
	
    [super dealloc];
}


@end
