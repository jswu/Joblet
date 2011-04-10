//
//  SWWebViewController.h
//  Joblet
//
//  Created by Sandy Wu on 11-04-05.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

@protocol SWWebViewControllerDelegate <NSObject>

@optional
- (void)requestDidFailLoadForWebView:(UIWebView *)myWebView withError:(NSError *)error;
- (void)requestDidFinishLoadForWebView:(UIWebView *)myWebView;

@end


@interface SWWebViewController : UIViewController <UIWebViewDelegate> {
	id<SWWebViewControllerDelegate> delegate;
	UIWebView *webView;
	NSURL *targetURL;
}

@property (nonatomic, assign) id<SWWebViewControllerDelegate> delegate;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSURL *targetURL;

- (id)initWithStringURL:(NSString *)urlString andDelegate:(id<SWWebViewControllerDelegate>)assignDelegate;
- (id)initWithURL:(NSURL *)url andDelegate:(id<SWWebViewControllerDelegate>)assignDelegate;
- (void)makeRequest;
- (void)adjustWebViewFrameToOrientation:(UIInterfaceOrientation)curInterfaceOrientation;

@end
