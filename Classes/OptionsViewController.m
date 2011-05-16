//
//  OptionsViewController.m
//  Joblet
//
//  Created by Sandy Wu on 11-04-10.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "OptionsViewController.h"


@implementation OptionsViewController

@synthesize optionTableView;
@synthesize picker, pickerDataSource, pickerDataSourceMapping;

- (id)init
{
	return [self initWithNibName:@"OptionsViewController" bundle:[NSBundle mainBundle]];
}

- (void)doneButtonPressed
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = kString_Options;
	self.optionTableView.backgroundColor = [UIColor clearColor];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																				   target:self 
																				   action:@selector(doneButtonPressed)];
									  
	self.navigationItem.rightBarButtonItem = doneButton;	
	
	if (self.pickerDataSource == nil)
	{
		self.pickerDataSource = [[NSArray alloc] initWithObjects:@"one", @"two", @"three", @"four",@"one", @"two", @"three", @"four",@"one", @"two", @"three", @"four", nil];
		[self.pickerDataSource release];
	}
	
	if (self.picker == nil)
	{
		self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		[self.picker release];
		self.picker.delegate = self;
		self.picker.dataSource = self;
	}

	// A mapping from a string in pickerDataSource to the corresponding name of the instnace variable in the a jobItem object

	// Temporarily disable, until better UI is designed
//	self.optionTableView.tableFooterView = picker;

	[doneButton release];
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

- (void)dealloc {
	[optionTableView release], optionTableView = nil;
	
	[picker	release], picker = nil;
	[pickerDataSource release], pickerDataSource = nil;
	[pickerDataSourceMapping release], pickerDataSourceMapping = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark UITableView Delegate/DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger retVal;
	switch (section) {
		case 0:
			retVal = kNumberOfShowInfoOptions;
			break;
		case 1:
			retVal = 1;
			break;
	}
	return retVal;
}

- (void)showInfoSwitchToggled:(UISwitch *)toggledSwitch
{
	// Assuming a read is less expensive than a write.
	if (![[NSUserDefaults standardUserDefaults] boolForKey:kKeyOptions_OptionsDidChange])
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKeyOptions_OptionsDidChange];
	[[NSUserDefaults standardUserDefaults] setBool:[toggledSwitch isOn] forKey:[NSString stringWithFormat:@"%@_%d", kKeyOptions_ShowInfo, [toggledSwitch tag]]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	UITableViewCell *cell;
	
	if (section == 0)
	{	
		cell = [tableView dequeueReusableCellWithIdentifier:@"ShowInfoCell"];
		
		if (cell == nil)
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShowInfoCell"] autorelease];
			cell.selectionStyle	 = UITableViewCellSelectionStyleNone;
			
			for (UIView *sub in [cell subviews])
				[sub removeFromSuperview];
			
			UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 178, 27)];
			cellTextLabel.font = [UIFont systemFontOfSize:18];
			[cell addSubview:cellTextLabel];
			[cellTextLabel release];
		}
		
		UILabel *cellTextLabel;
		
		for (UIView *sub in [cell subviews])
		{
			if ([sub isKindOfClass:[UILabel class]])
				cellTextLabel = (UILabel *)sub;
			else if ([sub isKindOfClass:[UISwitch class]])
				[sub removeFromSuperview];
		}
		
		NSString *cellText;
		UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(206, 8, 94, 27)];
		[cellSwitch addTarget:self action:@selector(showInfoSwitchToggled:) forControlEvents:UIControlEventValueChanged];
		[cellSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%d", kKeyOptions_ShowInfo, row]]];
		cellSwitch.tag = row;
		
		switch (row) {
			case kOptionsViewTableCellRowIndex_ShowJobID:
				cellText = kString_OptionsCellJobID;
				break;
			case kOptionsViewTableCellRowIndex_ShowJobTitle:
				cellText = kString_OptionsCellJobTitle;
				break;
			case kOptionsViewTableCellRowIndex_ShowEmployer:
				cellText = kString_OptionsCellEmployer;
				break;
			case kOptionsViewTableCellRowIndex_ShowUnit:
				cellText = kString_OptionsCellUnit;
				break;
			case kOptionsViewTableCellRowIndex_ShowTerm:
				cellText = kString_OptionsCellTerm;
				break;
			case kOptionsViewTableCellRowIndex_ShowJobStatus:
				cellText = kString_OptionsCellJobStatus;
				break;
			case kOptionsViewTableCellRowIndex_ShowLastDayToApply:
				cellText = kString_OptionsCellLastDayToApply;
				break;
			case kOptionsViewTableCellRowIndex_ShowNumberOfApps:
				cellText = kString_OptionsCellNumberOfApps;
				break;
			case kOptionsViewTableCellRowIndex_ShowInterviewers:
				cellText = kString_OptionsCellInterviewers;
				break;
			case kOptionsViewTableCellRowIndex_ShowInterviewRoom:
				cellText = kString_OptionsCellInterviewRoom;
				break;
			case kOptionsViewTableCellRowIndex_ShowRankByUser:
				cellText = kString_OptionsCellRankByUser;
				break;
			case kOptionsViewTableCellRowIndex_ShowRankByEmployer:
				cellText = kString_OptionsCellRankByEmployer;
				break;
		}
		
		cellTextLabel.text = cellText;
		[cell addSubview:cellSwitch];
	}
	else if (section == 1)
	{
		
	}
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0f;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
}
*/

#pragma mark
#pragma mark UIPickerView Delegate/Datasource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSLog(@"Selected sorting by %@", [self.pickerDataSource objectAtIndex:row]);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return [self.pickerDataSource count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [self.pickerDataSource objectAtIndex:row];
}

@end
