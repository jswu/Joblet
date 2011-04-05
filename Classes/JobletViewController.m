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
// HTML parsing
#import <libxml/xmlmemory.h>
#import <libxml/HTMLparser.h>
#import <libxml/xmlstring.h>

@implementation JobletViewController

@synthesize userID;
@synthesize password;
@synthesize loginButton;
@synthesize userMessages;
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
	NSString *ID = [[userID.text copy] stringAfterTrim];
	if ([ID length] == 0)
	{
		self.userMessages.text = NSLocalizedString(@"Please enter your User ID.", @"Warning message when user leaves User ID field blank");
		return;
	}

	NSString *PW = [[password.text copy] stringAfterTrim];
	if ([PW length] == 0)
	{
		self.userMessages.text = NSLocalizedString(@"Please enter your password.", @"Warning message when user leaves password field blank");
		return;
	}
	
	self.loginButton.enabled = NO; // This will not be needed after a loading view is added
	self.userMessages.text = @"";
	self.password.text = @"";

//	NSLog(@"Username: %@", userID.text);
//	NSLog(@"Password: %@", password.text);

	NSString *stringForURL = [[NSString alloc] initWithFormat:@"https://jobmine.ccol.uwaterloo.ca/servlets/iclientservlet/ES/?cmd=login&languageCd=ENG&sessionId="];

	NSURL *URL = [[NSURL alloc] initWithString:stringForURL];	
	[stringForURL release];
	
	self.formRequest = [[ASIFormDataRequest alloc] initWithURL:URL];
	[URL release];
	
	/*
	 https://jobmine.ccol.uwaterloo.ca/servlets/iclientservlet/ES/?cmd=login&languageCd=ENG&sessionId=
	 Jobmine form fields
	 Replace credentials with your own.
	 timezoneOffset:300
	 userid:USERNAME
	 pwd:PASSWORD
	 submit:Submit
	 
	 Alternatively save the pages of interest and store them on your own server to test the html parsing.
	 
	 */
	
	[formRequest setPostValue:[NSNumber numberWithInteger:300] forKey:@"timezoneOffset"];
	[formRequest setPostValue:ID forKey:@"userid"];
	[formRequest setPostValue:PW forKey:@"pwd"];
	[formRequest setPostValue:@"Submit" forKey:@"submit"];
	
	[ID release];
	[PW release];
	// Add request headers here
	
	// Bring up loading screen
	
	self.formRequest.delegate = self;
//	[self fetchApplicationPage]; // Skips to test html parsing
	NSLog(@"New debugging");
	
	[self.formRequest startAsynchronous];
	// TODO: loading spinner
}

- (IBAction)backgroundTapped:(id)sender
{
	[userID resignFirstResponder];
	[password resignFirstResponder];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
 
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Login", @"Login view header");
	
	self.userMessages.textAlignment = UITextAlignmentCenter;
	self.userMessages.numberOfLines = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// We disabled the button upon login
	self.loginButton.enabled = YES;
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
	userID = nil;
	password = nil;
}


- (void)dealloc {
	[userID release];
	[password release];
	[loginButton release];
	[userMessages release];
	[formRequest release];
	
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
		
		// TODO: code for extracting appStatusCode
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

- (void)fetchApplicationPage
{
	defaultIndent = [[NSString alloc] initWithString:@" "];
	NSLog(@"Began fetching application page");
		
 	NSString *stringForURL = [[NSString alloc] initWithFormat:@"https://jobmine.ccol.uwaterloo.ca/servlets/iclientservlet/ES/?ICType=Panel&Menu=UW_CO_STUDENTS&Market=GBL&PanelGroupName=UW_CO_APP_SUMMARY&RL=&target=main0&navc=4844"];
	
	NSURL *URL = [[NSURL alloc] initWithString:stringForURL];	
	[stringForURL release];
	
	self.formRequest = [[ASIFormDataRequest alloc] initWithURL:URL];
	[URL release];
	[self.formRequest startSynchronous];
	
	NSString *applicationPage = [self.formRequest responseString];
	
	//NSLog(@"file content:\n%@", applicationPage);
	
	NSLog(@"Commencing html parse:");
	
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
}

- (void)parseLoginPage:(htmlNodePtr)node
{
	
}

#pragma mark --
#pragma mark ASIHTTPRequest Delegate Methods

/* Finished reuqest from initial login has the following possibilities:
 *	-Sucessful login
 *	-Invalid credentials
 *	-Access denied (probably due to current time; JobMine is offline). Not sure if a user can be denied for other reason
 *	-No internet connection (should fall into requestFailed:)
 */

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
			[HelperFunction showErrorAlertMsg:NSLocalizedString(@"An error was encounter when attempting to access JobMine. Please check your connection and try again.", @"A blank page was returned. Report error and prompt user to try again")];
			self.loginButton.enabled = YES;
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
			}
			
		}
		else
		{
			[HelperFunction showErrorAlertMsg:[NSString stringWithFormat:kString_GenericErrorMessage, kErrorCode_NullLoginHTMLDoc]];
		}
		
		[response release];
		/*
		 
		 
		 // Sample to copy from
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
		 
		 
		 if ([self.formRequest responseString] != nil)
		 response = [[NSString alloc] initWithString:[self.formRequest responseString]];
		 else
		 {
		 // Page response was null, present error message to retry
		 [HelperFunction showErrorAlertMsg:NSLocalizedString(@"An error was encounter when attempting to access JobMine. Please check your connection and try again.", @"A blank page was returned. Report error and prompt user to try again")];
		 return;
		 }
		 
		 if (response != nil)
		 {
		 // TODO: parse the page to see whether the login was successful or not
		 NSLog(@"The response data is:\n%@", response);
		 NSLog(@"Non-empty page retrieved");
		 }
		 else
		 {
		 NSLog(@"JobLetViewController:\nrequestFinished: The response was nil.");
		 return;
		 }
		 */
	}
	else
	{
		NSLog(@"JobLetViewController:\nrequestFinished: Error on login.");
		// Error handling
		[HelperFunction showErrorAlertMsg:[NSString stringWithFormat:kString_GenericErrorMessage, kErrorCode_BlankLoginResponse]];
		return;
	}
	
	NSLog(@"Now fetching interviews page");
	[self fetchApplicationPage];
	
	if ([[UserJobDatabase getJobIDList] count] == 0)
	{
		[HelperFunction showAlertMsg:NSLocalizedString(@"You do not have any active applied jobs.", @"When trying to login with no jobs in the job Application page") 
						   withTitle:NSLocalizedString(@"Information", @"Alert heading for general informative alerts")];
		self.loginButton.enabled = YES;
		
	}
	else
	{
		// load the table view here
		JobOverviewViewController *nextView = [[JobOverviewViewController alloc] init];
		[self.navigationController pushViewController:nextView animated:YES];
		[nextView release];
		
		// Clear the user name since the user successfully logged in
		userID.text = @"";
		
		// Fetch the other pages in the background
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"request Failed.");
	[HelperFunction showAlertCheckConnection];
	self.loginButton.enabled = YES;

}

- (void)requestRedirected:(ASIHTTPRequest *)request
{
	NSLog(@"request Reditected.");
}


@end
