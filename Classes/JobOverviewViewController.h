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

@interface JobOverviewViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, 
SWWebViewControllerDelegate> {
	NSIndexPath				*_lastSelectedRowIndexPath;
	
	NSArray					*cachedRowData;
	NSMutableArray			*newCachedRowData;
	IBOutlet UITableView	*jobTableView;
	
	SWWebViewController		*jobDetailsViewController;
}

@property (retain) NSArray							*cachedRowData;
@property (retain) NSMutableArray					*newCachedRowData;
@property (nonatomic, retain) IBOutlet UITableView	*jobTableView;
@property (nonatomic, retain) SWWebViewController	*jobDetailsViewController;

- (void)updateTable;

- (void)logoutButtonPressed;
- (void)optionsButtonPressed;

@end
