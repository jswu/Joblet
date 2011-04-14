    //
//  JobOverviewViewController.m
//  Joblet
//
//  Created by Sandy Wu on 11-03-02.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "JobOverviewViewController.h"
#import "UserJobDatabase.h"
#import "SWLoadingView.h"
#import "OptionsViewController.h"


@implementation JobOverviewViewController

@synthesize cachedRowData, newCachedRowData;
@synthesize jobTableView;
@synthesize jobDetailsViewController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
 
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	NSLog(@"Commencing loadview");	
	view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	jobTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
	[jobTableView setDelegate:self];
	[jobTableView setDataSource:self];
	[self.view addSubview:jobTableView];
	
	self.navigationItem.title = kString_JobInformation;
	
	UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:kString_Logout
																	 style:UIBarButtonItemStyleBordered 
																	target:self 
																	action:@selector(logoutButtonPressed)];
	self.navigationItem.leftBarButtonItem = logoutButton;
	[logoutButton release];
	
	
	UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithTitle:kString_Options
																	  style:UIBarButtonItemStyleBordered 
																	 target:self 
																	 action:@selector(optionsButtonPressed)];
	self.navigationItem.rightBarButtonItem = optionsButton;	
	[optionsButton release];
	
	
	self.cachedRowData = (NSArray *)[UserJobDatabase getJobIDList];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:kKeyOptions_OptionsDidChange])
		[[self jobTableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (_lastSelectedRowIndexPath != nil)
	{
		[self.jobTableView deselectRowAtIndexPath:_lastSelectedRowIndexPath animated:animated];
		[_lastSelectedRowIndexPath release], _lastSelectedRowIndexPath = nil;
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	NSLog(@"JobOveriewViewController dealloc");
	[cachedRowData release], cachedRowData = nil;
	[newCachedRowData release], newCachedRowData = nil;
	
	[jobTableView release], jobTableView = nil;

	[jobDetailsViewController release], jobDetailsViewController = nil;
    
	[super dealloc];
}

#pragma mark -
#pragma mark Row Data Managemet

- (void)updateTable
{
	self.cachedRowData = [NSArray arrayWithArray:newCachedRowData];
	[jobTableView reloadData];
}
					
#pragma mark -
#pragma mark UI Button Presses
- (void)logoutButtonPressed
{
	[UserJobDatabase userLoggedOut];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)optionsButtonPressed
{
	OptionsViewController *vc = [[OptionsViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self.navigationController presentModalViewController:nav animated:YES];
	[nav release];
	[vc release];
}

#pragma mark -
#pragma mark UITableViewDataSource Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"There are %d rows", [[self cachedRowData] count] + 1);
	return [[self cachedRowData] count];
}

- (NSString *)infoStringForJobItem:(JobItem *)job
{
	NSString *infoText = @"";
	
	// Use a loop here so that we can easily allow the user to change the order of the listed job field (to be implemented at a later time)
	for (int i=0;i<kNumberOfShowInfoOptions;i++)
	{
		// Only show fields enabled ny the user
		if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_%d", kKeyOptions_ShowInfo, i]])
		{
			NSString *tempInfo;
			switch (i) {
				case kOptionsViewTableCellRowIndex_ShowJobTitle:
					tempInfo = job.jobTitle;
					break;
				case kOptionsViewTableCellRowIndex_ShowEmployer:
					tempInfo = job.employer;
					break;
				case kOptionsViewTableCellRowIndex_ShowUnit:
					tempInfo = job.unit;
					break;
				case kOptionsViewTableCellRowIndex_ShowNumberOfApps:
					tempInfo = [job.numberOfApps stringValue];
					break;
				case kOptionsViewTableCellRowIndex_ShowJobStatus:
					tempInfo = job.jobStatus;
					break;
				case kOptionsViewTableCellRowIndex_ShowTerm:
					tempInfo = job.term;
					break;
				case kOptionsViewTableCellRowIndex_ShowLastDayToApply:
					tempInfo = job.lastDayToApply;
					break;
				case kOptionsViewTableCellRowIndex_ShowJobID:
					tempInfo = job.jobIDString;
					break;
				case kOptionsViewTableCellRowIndex_ShowInterviewers:
					tempInfo = job.interviewers;
					break;
				case kOptionsViewTableCellRowIndex_ShowInterviewRoom:
					tempInfo = job.interviewRoom;
					break;
				case kOptionsViewTableCellRowIndex_ShowRankByUser:
					tempInfo = [job.rankByUser stringValue];
					break;
				case kOptionsViewTableCellRowIndex_ShowRankByEmployer:
					tempInfo = [job.rankByEmployer stringValue];
					break;
			}
			
			if (tempInfo == nil || [tempInfo isEqualToString:@""]) // Shouldn't be nil, but check just to be safe
				tempInfo = kString_NA;
			
			infoText = [infoText stringByAppendingFormat:@"%@\n", tempInfo];
		}
	}
	
	infoText = [infoText stringAfterTrim];
	
	// Force employer and job title if nothign is enabled. Temporary, should decide later if this is the best options.
	if ([infoText isEqualToString:@""])
		infoText = [NSString stringWithFormat:@"%@\n%@", job.employer, job.jobTitle];
	
	return infoText;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobInfoCell"];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"JobInfoCell"] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.detailTextLabel.numberOfLines = 0;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
	}
	
	JobItem *job = [UserJobDatabase getJobItemForJobID:[[self cachedRowData] objectAtIndex:row]];

	/// Job title and employer
	if (![job.appStatus isEqualToString:@""])
		cell.textLabel.text = [NSString stringWithString:job.appStatus];
	else
		cell.textLabel.text = [NSString stringWithString:kString_NA]; // @"" String makes the label collapse
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	
	cell.detailTextLabel.text = [self infoStringForJobItem:job];
	
	return cell;
	
}
#pragma mark -
#pragma mark UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;
	JobItem *job = [UserJobDatabase getJobItemForJobID:[[self cachedRowData] objectAtIndex:row]];

	// TODO: Need to cache the info string so we don't need to compute it twice.
	// Low priority, since performance isn't a big issue right now anyway (the app does so little).
	NSString *cellText = [self infoStringForJobItem:job];
	UIFont *cellFont = [UIFont systemFontOfSize:12]; 
	CGSize constraintSize = CGSizeMake(200.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
    return labelSize.height + 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	JobItem *job = [UserJobDatabase getJobItemForJobID:[[self cachedRowData] objectAtIndex:indexPath.row]];
	 
	NSString *jobID = job.jobIDString;
	if ([jobID isEqualToString:@""])  // No ID found during scrapping
	{
		// This should be very unlikely, if at all possible since every job should have a job ID (at least from what I've seen).
		// Though if this is an issue, we could try to generate the job details page link using other job item information.
		// The link generated by JobMine uses almost all the fields of a job item.
		// I find that to be excessive, and under the assumption that every job has a unique job ID, supplying only the job ID shold do.
		[HelperFunction showErrorAlertMsg:kString_NoJobDetailsPageFound];
		return;
	}
	// TODO: Check connection, error out if necessary
	
	// TODO: Check if session with JobMine is still valid, error out if necessary
	
	[SWLoadingView show];
	
	// Remember which row was click to fade later.
	_lastSelectedRowIndexPath = [indexPath copy];
	
	NSString *URLStr = [[NSString alloc] initWithFormat:kJobMineURL_JobDetailsPageBaseURL, jobID];
	// TODO: Should look into caching the pages so the usr doesn't have to fetch them twice.
	// But not sure if the staff at JobMine would approve of that (maybe it counts as storing JobMine infromation).
	// If we do end up caching the, we should reuse the jobDetailsViewController.
	self.jobDetailsViewController = [[SWWebViewController alloc] initWithStringURL:URLStr andDelegate:self];
	[URLStr release];
	// Property is set to retain and we alloc'd, release one.
	[self.jobDetailsViewController release];
	[self.jobDetailsViewController makeRequest];
}

#pragma mark -
#pragma mark UIAlertView Delegate Methods

#pragma mark -
#pragma mark SWWebViewController Delegate Methods
- (void)requestDidFailLoadForWebView:(UIWebView *)myWebView withError:(NSError *)error
{
	[SWLoadingView hide];
	[self.jobTableView deselectRowAtIndexPath:_lastSelectedRowIndexPath animated:YES];
	[_lastSelectedRowIndexPath release], _lastSelectedRowIndexPath = nil;
	
	[HelperFunction showAlertCheckConnection];
	self.jobDetailsViewController = nil;
}

- (void)requestDidFinishLoadForWebView:(UIWebView *)myWebView
{
	[SWLoadingView hide];
	
	[self.navigationController pushViewController:jobDetailsViewController animated:YES];	
	self.jobDetailsViewController = nil;
	
}

@end
