//
//  OptionsViewController.h
//  Joblet
//
//  Created by Sandy Wu on 11-04-10.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

@interface OptionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *optionTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *optionTableView;

@end
