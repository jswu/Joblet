//
//  JobOverviewViewController.h
//  Joblet
//
//  Created by Sandy Wu on 11-03-02.
//  Copyright 2011 Sandy Wu. All rights reserved.
//	

#import <UIKit/UIKit.h>
#import "SWWebViewController.h"

@class SWWebViewController;
@class JobItem;

@interface JobOverviewViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, 
SWWebViewControllerDelegate> {
	NSIndexPath				*_lastSelectedRowIndexPath;
	
	NSArray					*cachedRowData;
	NSArray					*cachedRowInfoStrings;
	IBOutlet UITableView	*jobTableView;
	
	SWWebViewController		*jobDetailsViewController;
}

@property (nonatomic, retain) NSArray				*cachedRowData;
@property (nonatomic, retain) NSArray				*cachedRowInfoStrings;
@property (nonatomic, retain) IBOutlet UITableView	*jobTableView;
@property (nonatomic, retain) SWWebViewController	*jobDetailsViewController;

- (void)rebuildJobTableCacheWithNewSortedOrder:(BOOL)shouldSort;
- (NSString *)infoStringForJobItem:(JobItem *)job;

- (void)logoutButtonPressed;
- (void)optionsButtonPressed;

@end
