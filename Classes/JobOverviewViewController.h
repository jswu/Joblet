//
//  JobOverviewViewController.h
//  Joblet
//
//  Created by Sandy Wu on 11-03-02.
//  Copyright 2011 Sandy Wu. All rights reserved.
//	

#import <UIKit/UIKit.h>
#import "SWWebViewController.h"


@interface JobOverviewViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, 
SWWebViewControllerDelegate> {
	NSArray					*cachedRowData;
	NSMutableArray			*newCachedRowData;
	IBOutlet UITableView	*jobTableView;
	
	NSIndexPath				*_lastSelectedRowIndexPath;
}

@property (retain) NSArray							*cachedRowData;
@property (retain) NSMutableArray					*newCachedRowData;
@property (nonatomic, retain) IBOutlet UITableView	*jobTableView;

- (void)updateTable;

- (void)logoutButtonPressed;
- (void)optionsButtonPressed;

@end
