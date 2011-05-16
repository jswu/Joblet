//
//  OptionsViewController.h
//  Joblet
//
//  Created by Sandy Wu on 11-04-10.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

@interface OptionsViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, 
UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UITableView *optionTableView;
	
	UIPickerView *picker;
	NSArray *pickerDataSource;
	NSDictionary *pickerDataSourceMapping;
}

@property (nonatomic, retain) IBOutlet UITableView *optionTableView;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) NSArray *pickerDataSource;
@property (nonatomic, retain) NSDictionary *pickerDataSourceMapping;

@end
