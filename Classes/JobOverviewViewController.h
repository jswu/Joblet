//
//  JobOverviewViewController.h
//  Joblet
//
//  Created by Sandy Wu on 11-03-02.
//  Copyright 2011 Sandy Wu. All rights reserved.
//	

#import <UIKit/UIKit.h>
#import "SWWebViewController.h"
#import "PullRefreshTableViewController.h"

@class SWWebViewController;
@class JobItem;
@class JobletViewController;

@interface JobOverviewViewController : PullRefreshTableViewController 
<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, 
SWWebViewControllerDelegate> {
	NSIndexPath				*_lastSelectedRowIndexPath;
	
	NSArray					*cachedRowData;
	NSArray					*cachedRowInfoStrings;
	
	SWWebViewController		*jobDetailsViewController;
	
	// Temporary to get refresh working
	JobletViewController *jvc;
}

@property (nonatomic, retain) NSArray				*cachedRowData;
@property (nonatomic, retain) NSArray				*cachedRowInfoStrings;
@property (nonatomic, retain) SWWebViewController	*jobDetailsViewController;

// Temporary to get refresh working
@property (nonatomic, assign) JobletViewController *jvc;

- (void)rebuildJobTableCacheWithNewSortedOrder:(BOOL)shouldSort;
- (NSString *)infoStringForJobItem:(JobItem *)job;

- (void)logoutButtonPressed;
- (void)optionsButtonPressed;

@end
