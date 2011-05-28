//
//  JobletViewController.m
//  Joblet
//
//  Created by Sandy Wu on 11-01-10.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "JobletViewController.h"
#import "UserJobDatabase.h"
#import "JobOverviewViewController.h"
#import "SWLoadingView.h"
#import "OptionsViewController.h"
#import "NetworkOperations.h"
#import "AboutViewController.h"
#import "SFHFKeychainUtils.h"
// HTML parsing
#import <libxml/xmlmemory.h>
#import <libxml/HTMLparser.h>
#import <libxml/xmlstring.h>

@implementation JobletViewController

@synthesize userID;
@synthesize password;
@synthesize loginButton;
@synthesize userMessages;
@synthesize rememberMeSwitch;
@synthesize tempUserID, tempPassword;
@synthesize formRequest;


- (IBAction)userIDDoneEditing:(id)sender
{
	[userID resignFirstResponder];
	[password becomeFirstResponder];
}

- (IBAction)passwordDoneEditing:(id)sender
{
 	[password resignFirstResponder];
	[self loginButtonPressed:sender];
}

- (IBAction)loginButtonPressed:(id)sender
{
	self.tempUserID = [userID.text stringAfterTrim];
	if ([self.tempUserID length] == 0)
	{
		self.userMessages.text = kString_UserIDRequired;
		return;
	}

	self.tempPassword = [password.text stringAfterTrim];
	if ([self.tempPassword length] == 0)
	{
		self.userMessages.text = kString_PasswordRequired;
		return;
	}
	
	// Clear the error messages for blank userID or password
	self.userMessages.text = @"";
	    
	/*
	 Check Constants.h for kJobMineURL_LoginForm
	 Jobmine form fields
	 Replace credentials with your own.
	 timezoneOffset:300
	 userid:USERNAME
	 pwd:PASSWORD
	 submit:Submit
	 */
	
	NSString *stringForURL = [[NSString alloc] initWithFormat:kJobMineURL_LoginForm];
	NSURL *URL = [[NSURL alloc] initWithString:stringForURL];
	self.formRequest = [[ASIFormDataRequest alloc] initWithURL:URL];
	[self.formRequest release];
	[formRequest setPostValue:[NSNumber numberWithInteger:300] forKey:@"timezoneOffset"];
	[formRequest setPostValue:self.tempUserID forKey:@"userid"];
	[formRequest setPostValue:self.tempPassword forKey:@"pwd"];
	[formRequest setPostValue:@"Submit" forKey:@"submit"];
	[formRequest setDelegate:self];
	
	[stringForURL release];
	[URL release];
	
	if (![NetworkOperations hasNetworkConnection])
	{
		[HelperFunction showAlertCheckConnection];
		return;
	}
	else
	{
		// Bring up loading screen
		[SWLoadingView show];
		// Clear password field for security, if the user does not have "Remember me" enabled
        if (![rememberMeSwitch isOn])
            self.password.text = @"";
		// Slide keyboard down automatically
		[userID resignFirstResponder];
		[password resignFirstResponder];
	//	[NetworkOperations requestToLoginWithUserID:self.tempUserID password:self.tempPassword callback:@selector(loginPageRequestCallback:) on:self]);
		[self.formRequest startAsynchronous];
	}
}

- (IBAction)backgroundTapped:(id)sender
{
	[userID resignFirstResponder];
	[password resignFirstResponder];
}

- (IBAction)rememberMeSwitchToggled:(id)sender
{
    BOOL switchStateIsOn = [self.rememberMeSwitch isOn];
    
    // Switch value has already changed, if it is now toggled to Off, then clear data
    if (!switchStateIsOn)
    {
        // Only delete the UserID/Password pair if a UserID exists
        NSString *storedUsername = [[NSUserDefaults standardUserDefaults] objectForKey:kKeySFHF_StoredUsername];
        
        if (storedUsername != nil && ![storedUsername isEqualToString:@""])
        {
            NSError *error = nil;
            [SFHFKeychainUtils deleteItemForUsername:storedUsername andServiceName:kSFHF_ServiceName error:&error];
            
            if (error == nil)
            {
                NSLog(@"JobletViewController: Success in DELETING keychain data after toggling remember me switch.");
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kKeySFHF_StoredUsername];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                NSLog(@"JobletViewController: Error DELETING keychain data after toggling remember me switch:\n%@", error);
                [HelperFunction showErrorAlertMsg:kString_FailedToClearCredentials];
                [self.rememberMeSwitch setOn:YES animated:YES];
            }
        }
    }
    
    // Store the current switch state (may have changed due to error)
    switchStateIsOn = self.rememberMeSwitch.on;
    [[NSUserDefaults standardUserDefaults] setBool:switchStateIsOn forKey:kKeySFHF_SwitchStateIsOn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)optionsButtonPressed
{
	OptionsViewController *vc = [[OptionsViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self.navigationController presentModalViewController:nav animated:YES];
	[nav release];
	[vc release];
}

- (void)aboutButtonPressed
{
	AboutViewController *vc = [[AboutViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self.navigationController presentModalViewController:nav animated:YES];
	[nav release];
	[vc release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = kString_LoginToJobMine;
	
	self.userMessages.textAlignment = UITextAlignmentCenter;
	self.userMessages.numberOfLines = 0;
	
	UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithTitle:kString_Options
																	  style:UIBarButtonItemStyleBordered 
																	 target:self 
																	 action:@selector(optionsButtonPressed)];
	self.navigationItem.rightBarButtonItem = optionsButton;	
    
	UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithTitle:kString_About
                                                                    style:UIBarButtonItemStyleBordered 
                                                                    target:self 
                                                                    action:@selector(aboutButtonPressed)];
	self.navigationItem.leftBarButtonItem = aboutButton;
    
	[optionsButton release];
	[aboutButton release];
    
    // The login button
    NSArray *loginTitle = [[NSArray alloc] initWithObjects:kString_Login, nil];
    self.loginButton = [[UISegmentedControl alloc] initWithItems:loginTitle];
    [self.loginButton release];
    CGRect frame = CGRectMake(115, 200, 87, 35);
    self.loginButton.frame = frame;
    
    self.loginButton.selectedSegmentIndex = -1;
    [self.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventValueChanged];
    
    self.loginButton.segmentedControlStyle = UISegmentedControlStyleBar;
    self.loginButton.tintColor = [UIColor colorWithRed:0/255.0f green:130.0f/255.0f blue:200.0f/255.0f alpha:0.8f];
    self.loginButton.momentary = YES;
    self.loginButton.alpha = 0.9;
    [self.view addSubview:self.loginButton];
}	

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Restore the last switch state
    self.rememberMeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kKeySFHF_SwitchStateIsOn];
    
    // Switch is current set to on, load the stored credentials
    if ([self.rememberMeSwitch isOn])
    {
        // Only load the UserID/Password pair if a UserID exists
        NSString *storedUsername = [[NSUserDefaults standardUserDefaults] objectForKey:kKeySFHF_StoredUsername];
        
        if (storedUsername != nil && ![storedUsername isEqualToString:@""])
        {
            NSError *error = nil;
            NSString *storedPassword = [SFHFKeychainUtils getPasswordForUsername:storedUsername andServiceName:kSFHF_ServiceName error:&error];
            
            if (error == nil)
            {
                NSLog(@"JobletViewController: Success in RETRIEVING keychain data after viewWillAppear.");
                self.userID.text = storedUsername;
                self.password.text = storedPassword;
            }
            else
                NSLog(@"JobletViewController: Error RETRIEVING keychain data after viewWillAppear:\n%@", error);
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	// Clear the user name if the user successfully logged in
	if ([[self.navigationController visibleViewController] isKindOfClass:[JobOverviewViewController class]])
		userID.text = @"";
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.userID = nil;
	self.password = nil;
	self.loginButton = nil;
	self.userMessages = nil;
    self.rememberMeSwitch = nil;
}


- (void)dealloc {
	[userID release], userID = nil;
	[password release], password = nil;
	[loginButton release], loginButton = nil;
	[userMessages release], userMessages = nil;
    [rememberMeSwitch release], rememberMeSwitch = nil;
	[tempUserID release], tempUserID = nil;
	[tempPassword release], tempPassword = nil;
	[formRequest release], formRequest = nil;
	
    [super dealloc];
}

// TODO: Refactor this method later, was in a hurry to get it working
// Not sure if these macros are a good idea...but keep them for now
#define NODE_IS_STILL_VALID		(validNode && !xmlStrcasecmp(node->name, (const xmlChar*)"td") && (node->children) && ((node->children)->content))
// Skip the next blank tag and get the next td
#define ADVANCE_TO_NEXT_NODE(n)	if ( !((n) = (n)->next) || !((n) = (n)->next) ) validNode = NO;
- (void)parseJobItemDataFromNode:(htmlNodePtr)node
{
	// There are probably improvements I can make to the parsing, but this works  (as of March 1st, 2011).
	// So get it working and re-factor later
	BOOL validNode = YES;
	JobItem *job = [[JobItem alloc] init];
	if ((node->children) && ((node->children)->content))
		NSLog(@"children %@", [[NSString stringWithUTF8String:(const char*)(node->children->content)] stringAfterTrim]);
	else {
		NSLog(@"Is null");
	}

	// Get the job ID
	if (NODE_IS_STILL_VALID)
	{
		NSString *content = [[NSString stringWithUTF8String:(const char*)(node->children->content)] stringAfterTrim];
		
		// Get the string version to generate the job details link
		job.jobIDString = content;
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		
		job.jobID = [formatter numberFromString:content];
		[formatter release];
		ADVANCE_TO_NEXT_NODE(node);
	}
	else
	{
		validNode = NO;
	}

	// Get the job title
	// The title is nested 2-levels down
	htmlNodePtr tempNode;
	
	// Traverse to the content whle asserting the pointers
	if (NODE_IS_STILL_VALID &&
		(tempNode = node->children) &&
		(tempNode = tempNode->next) &&
		(tempNode = tempNode->children) &&
		(tempNode = tempNode->next) &&
		(tempNode->children))
	{
		NSString *content = [[NSString stringWithUTF8String:(const char*)(tempNode->children->content)] stringAfterTrim];
		
		job.jobTitle = content;
		ADVANCE_TO_NEXT_NODE(node);
	}
	else
	{
		validNode = NO;
	}
	
	// Get the employer
	if (NODE_IS_STILL_VALID)
	{
		NSString *content = [[NSString stringWithUTF8String:(const char*)(node->children->content)] stringAfterTrim];
		
		job.employer = content;
		ADVANCE_TO_NEXT_NODE(node);
	}
	else
	{
		validNode = NO;
	}
	
	// Get the unit
	if (NODE_IS_STILL_VALID)
	{
		NSString *content = [[NSString stringWithUTF8String:(const char*)(node->children->content)] stringAfterTrim];
		
		job.unit = content;
		ADVANCE_TO_NEXT_NODE(node);
	}
	else
	{
		validNode = NO;
	}
	
	// Get the term
	if (NODE_IS_STILL_VALID)
	{
		NSString *content = [[NSString stringWithUTF8String:(const char*)(node->children->content)] stringAfterTrim];
		
		job.term = content;
		
		// TODO: code for extracting term code
		ADVANCE_TO_NEXT_NODE(node);
	}
	else
	{
		validNode = NO;
	}
	
	// Get the job status
	if (NODE_IS_STILL_VALID)
	{
		NSString *content = [[NSString stringWithUTF8String:(const char*)(node->children->content)] stringAfterTrim];
		
		job.jobStatus = content;
		
		// TODO: code for extracting jobStatusCode
		ADVANCE_TO_NEXT_NODE(node);
	}
	else
	{
		validNode = NO;
	}
	
	// Get the app status
	if (NODE_IS_STILL_VALID)
	{
		NSString *content = [[NSString stringWithUTF8String:(const char*)(node->children->content)] stringAfterTrim];
		
		job.appStatus = content;
		[job configureAppStatusCodeAndColour];

		ADVANCE_TO_NEXT_NODE(node);
		// Next field is either a "View Details" or "Edit Application" link, which is useless to us, for now...
		ADVANCE_TO_NEXT_NODE(node);
	}
	else
	{
		validNode = NO;
	}
	
	// Get the last day to apply
	if (NODE_IS_STILL_VALID)
	{
		NSString *content = [[NSString stringWithUTF8String:(const char*)(node->children->content)] stringAfterTrim];
		
		job.lastDayToApply = content;
		
		// TODO: code for extracting last day to apply date
		ADVANCE_TO_NEXT_NODE(node);
	}
	else
	{
		validNode = NO;
	}
	
	// Get the number of apps
	if (NODE_IS_STILL_VALID)
	{
		
		NSString *content = [[NSString stringWithUTF8String:(const char*)(node->children->content)] stringAfterTrim];
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		
		job.numberOfApps = [formatter numberFromString:content];
		
		[formatter release];
		ADVANCE_TO_NEXT_NODE(node);
	}
	else
	{
		validNode = NO;
	}
	
	// No problems were encountered, node was successfully parsed
	if (validNode)
		[UserJobDatabase addJobItem:job];
}

// This part is really messy. Was just learning XML-parsing 
// TODO: Clean up
static NSString *defaultIndent = nil;
- (void)parseNode:(htmlNodePtr)node withIndent:(NSString *)indent // For debugging purposes
{
	// Do nothing if the node is null
	if (!node)
		return;
	
	// We only care about element nodes
//	if (node->type != XML_ELEMENT_NODE)
//		return;
		
	//NSLog(@"%@Content: %s", indent, node->name);
	for (htmlNodePtr curNode = node; curNode ; curNode = curNode->next)
	{
//		NSLog(@"%@Name: %s", indent, (char *)curNode->name);
//		NSLog(@"%@Properties: %s", indent, (char *)node->properties);
//		if (xmlStrcasecmp(curNode->name, (const xmlChar*)"text") && curNode->children != NULL)
//			NSLog(@" %@Content: %s", indent, curNode->children->content);
		// TODO: Find more criteria to filter nodes with
		if (!xmlStrcasecmp(curNode->name, (const xmlChar*)"tr") && curNode->children != NULL)
			[self parseJobItemDataFromNode:(curNode->children)];
		[self parseNode:curNode->children withIndent:[NSString stringWithFormat:@"%@%@", indent, defaultIndent]];
	}
}

// TODO: Have to move this to Network Operations/HelperFunction
// Kind of hacked this to get refresh working...This is temporary until NetworkOperations is finishes
- (void)fetchApplicationPage:(NSArray *)params
{
    // Also temporary, to prevent leaks when called form the background thread
    NSAutoreleasePool *pool;
    if (![NSThread isMainThread])
        pool = [[NSAutoreleasePool alloc] init];
	
	defaultIndent = [[NSString alloc] initWithString:@" "];
	NSLog(@"Began fetching application page");
	
 	NSString *stringForURL = [[NSString alloc] initWithFormat:kJobMineURL_ApplicationPage];
	
	NSURL *URL = [[NSURL alloc] initWithString:stringForURL];	
	self.formRequest = [[ASIFormDataRequest alloc] initWithURL:URL];
	[self.formRequest startSynchronous];
	[stringForURL release];
	[URL release];
	NSString *response = [self.formRequest responseString];

    if (response != nil)
    {
        NSLog(@"Application page response not nil.");
        
        NSString *applicationPage = [[NSString alloc] initWithString:response];
        
        xmlChar *applicationSectionHTML = xmlCharStrdup([applicationPage UTF8String]);
        htmlDocPtr applicationHTMLDoc = htmlParseDoc(applicationSectionHTML, NULL);
        
        if (applicationHTMLDoc != NULL)
        {
            htmlNodePtr applicationRoot = xmlDocGetRootElement(applicationHTMLDoc);
            if (applicationRoot != NULL)
            {
                NSLog(@"Traversing parse tree");
                [self parseNode:applicationRoot withIndent:[NSString stringWithString:@""]];
            }
            xmlFreeDoc(applicationHTMLDoc);
            applicationHTMLDoc = NULL;
        }
        xmlFreeDoc(applicationHTMLDoc);
        
        [applicationPage release];
    }
    
	// Temporary, to get refresh working
	if (params != nil)
	{
		// Make the request to reset the JobMine timeout
		[NetworkOperations resetJobMineTimeout];
		// Perform the callback
		SEL method = NSSelectorFromString([params objectAtIndex:0]);
		id target = [params objectAtIndex:1];
		[target performSelectorOnMainThread:method withObject:nil waitUntilDone:NO];
	}
    
    if (![NSThread isMainThread])
        [pool drain];
}

- (void)parseLoginPage:(htmlNodePtr)node
{
	
}

- (void)loginPageRequestCallback:(NSString *)response
{
	// Make a function to parse for errors on login
	//[HelperFunction parseLoginPageResponse];
}
	/*
	[self performSelectorOnMainThread:@selector(loginPageRequestCallbackOnMainThread:) withObject:response waitUntilDone:YES];
}

- (void)loginPageRequestCallbackOnMainThread:(NSString *)response
{
	
}
*/
#pragma mark --
#pragma mark ASIHTTPRequest Delegate Methods
// TODO: Re-factor all network related code. Create a class that performs etwork operations.
/* Finished reuqest from initial login has the following possibilities:
 *	-Sucessful login
 *	-Invalid credentials
 *	-Access denied (probably due to current time; JobMine is offline). Not sure if a user can be denied for other reason
 *  -JobMine is down (should be caught by requestFailed:)
 */
// Another case to consider is when the session expires.
// Though it will not happen here, since requestFinished: will only be called when establishing new sessions.
// This is just a reminder to take care of that case as well.
- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"request Finished.");
	// Prboably don't need to tag the requests, since only the login request will be asynchronous (so the loading spinner will spin).
	// Just working on HTML parsing now, have to do all the erorr handling later
	NSError *error = [self.formRequest error];
	if (!error)
	{
		NSString *response = [[self.formRequest responseString] copy];
		if (response == nil)
		{
			// Page response was null, present error message to retry
			[HelperFunction showErrorAlertMsg:kString_BlankLoginPageResponseErrorMessage];
			[SWLoadingView hide];
			return;
		}
		//				NSLog(@"The response data is:\n%@", response);
		
		xmlChar *loginHTML = xmlCharStrdup([response UTF8String]);
		htmlDocPtr loginHTMLDoc = htmlParseDoc(loginHTML, NULL);
		
		if (loginHTMLDoc != NULL)
		{
			htmlNodePtr loginRootNode = xmlDocGetRootElement(loginHTMLDoc);
			if (loginRootNode != NULL)
			{
				[self parseLoginPage:loginRootNode];
			}
			else
			{
				[HelperFunction showErrorAlertMsg:[NSString stringWithFormat:kString_GenericErrorMessage, kErrorCode_NullLoginHTMLNode]];
				[SWLoadingView hide];
			}
			
		}
		else
		{
			[HelperFunction showErrorAlertMsg:[NSString stringWithFormat:kString_GenericErrorMessage, kErrorCode_NullLoginHTMLDoc]];
			[SWLoadingView hide];
		}
		xmlFreeDoc(loginHTMLDoc);
		[response release];
	}
	else
	{
		NSLog(@"JobLetViewController:\nrequestFinished: Error on login.");
		// Error handling
		[HelperFunction showErrorAlertMsg:[NSString stringWithFormat:kString_GenericErrorMessage, kErrorCode_BlankLoginResponse]];
		[SWLoadingView hide];
		return;
	}
	
	NSLog(@"Now fetching application page");
	if (![NetworkOperations hasNetworkConnection])
	{
		[HelperFunction showAlertCheckConnection];
		return;
	}
	[self fetchApplicationPage:nil];
	
	// TODO: We may want to enable other features even though they have no job items in the applcation page.
	// Though those cases will need to be considered when we support more than just the Application page.
	if ([[UserJobDatabase getJobIDList] count] == 0)
	{
		// The user has no jobs on their account displayed through the applications page. Any uncaught errors would probably also end up here.
		[HelperFunction showErrorAlertMsg:kString_LoginFailedMultipleReasons];
		[SWLoadingView hide];
	}
	else
	{
        // The login was successful, save the UserID/Password if the remember me switch is on
        if ([self.rememberMeSwitch isOn])
        {
            NSError *error = nil;
            [SFHFKeychainUtils storeUsername:self.tempUserID andPassword:self.tempPassword forServiceName:kSFHF_ServiceName updateExisting:TRUE error:&error];
            
            if (error == nil)
            {
                NSLog(@"JobletViewController: Success in STORING keychain data after login.");
                [[NSUserDefaults standardUserDefaults] setObject:self.tempUserID forKey:kKeySFHF_StoredUsername];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
                NSLog(@"JobletViewController: Error STORING keychain data after login:\n%@", error);
        }

		[SWLoadingView hide];
		// load the table view here
		JobOverviewViewController *nextView = [[JobOverviewViewController alloc] init];
		nextView.jvc = self;
		[self.navigationController pushViewController:nextView animated:YES];
		[nextView release];
		
		// Fetch the other pages in the background, or synchronously...depending on the final design
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"request Failed.");
	[HelperFunction showAlertCheckConnection];
	[SWLoadingView hide];

}

- (void)requestRedirected:(ASIHTTPRequest *)request
{
	NSLog(@"request Reditected.");
}


@end
