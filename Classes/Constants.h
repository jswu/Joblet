//
//  Constants.h
//  Joblet
//
//  Created by Sandy Wu on 11-04-03.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#pragma mark -
#pragma mark All strings in app shown to user

#define kString_GenericErrorMessage					NSLocalizedString(@"An unexpected error was encounter, please try again later\nError code: %@", @"Generic unknown error message")
#define kString_NoJobDetailsPageFound				NSLocalizedString(@"Job details page not found.", @"Job details page link could not be generated simce job ID was blank")
#define kString_JobInformation						NSLocalizedString(@"Job Information", @"Job list view heading")
#define kString_Logout								NSLocalizedString(@"Logout", @"Job list view left bar item") 
#define kString_Options								NSLocalizedString(@"Options", @"Job list view right bar item")
#define kString_NA									NSLocalizedString(@"N/A", @"No data is available for a field of job item")
#define kString_UserIDRequired						NSLocalizedString(@"Please enter your User ID.", @"Warning message when user leaves User ID field blank")
#define kString_PasswordRequired					NSLocalizedString(@"Please enter your password.", @"Warning message when user leaves password field blank")
#define kString_Login								NSLocalizedString(@"Login", @"Login view header")
#define kString_LoginFailedMultipleReasons			NSLocalizedString(@"Could not login to JobMine. Please check your credentials and ensure that JobMine is available. (Alternatively this could also mean that you have no active applied jobs.)", @"The user's credentials are invalid or JobMine is under maintenace, or there are no active applied jobs")
#define kString_Information							NSLocalizedString(@"Information", @"Alert heading for general informative alerts")
#define kString_FailedToFetchJobDetailsPage			NSLocalizedString(@"An error was encounter while retrieving the job details, please try again later.", @"Failed to get the job details page for some reason (not because of internet connection)")
#define kString_BlankLoginPageResponseErrorMessage	NSLocalizedString(@"An error was encounter while connecting to JobMine. Please check your connection and try again.", @"A blank page was returned. Report error and prompt user to try again")
#define kString_NumberOfApplicants					NSLocalizedString(@"Number of applicants: %@", @"Text indicating the followingn umber is the number of applicants.")
#define kString_RefreshFailed						NSLocalizedString(@"Failed to refresh. Your session might have expired or JobMine is unavailable. Please try again later by logging out and then logging in.", @"Refreshing from the Job Overview failed.")

// Loading Message for SWLoadingView
#define kString_SW_Loading							NSLocalizedString(@"Loading...", @"Default loading message for the loading popup")

// Options cell text for OptionViewcontroller
#define kString_OptionsCellJobID					NSLocalizedString(@"Job ID Number", @"Options cell text for job ID");
#define kString_OptionsCellJobTitle					NSLocalizedString(@"Job Title", @"Options cell text for job title");
#define kString_OptionsCellEmployer					NSLocalizedString(@"Employer", @"Options cell text for employer");
#define kString_OptionsCellUnit						NSLocalizedString(@"Unit", @"Options cell text for unit");
#define kString_OptionsCellTerm						NSLocalizedString(@"Term", @"Options cell text for term");
#define kString_OptionsCellJobStatus				NSLocalizedString(@"Job Status", @"Options cell text for job title");
#define kString_OptionsCellLastDayToApply			NSLocalizedString(@"Last Day To Apply", @"Options cell text for last day to apply");
#define kString_OptionsCellNumberOfApps				NSLocalizedString(@"Number of Applicants", @"Options cell text for number of applicants");
#define kString_OptionsCellInterviewers				NSLocalizedString(@"Interviewers", @"Options cell text for interviewers");
#define kString_OptionsCellInterviewRoom			NSLocalizedString(@"Interview Room", @"Options cell text for interview room");
#define kString_OptionsCellRankByUser				NSLocalizedString(@"Rank By User", @"Options cell text for rank by user");
#define kString_OptionsCellRankByEmployer			NSLocalizedString(@"Rank By Employer", @"Options cell text for rank by employer");

// HelperFunction strings
#define kString_Error								NSLocalizedString(@"Error", "Error alert heading")
#define kString_CheckInternetConnection				NSLocalizedString(@"Could not connection to JobMine. Please make sure that you are connected to the internet and try again.", @"No internet connection error message")
#define kString_OK									NSLocalizedString(@"OK", "Button option")

#pragma mark -
#pragma mark JobMine URLS

#define kJobMineURL_LoginForm						@"https://jobmine.ccol.uwaterloo.ca/servlets/iclientservlet/ES/?cmd=login&languageCd=ENG&sessionId="
#define kJobMineURL_ApplicationPage					@"https://jobmine.ccol.uwaterloo.ca/servlets/iclientservlet/ES/?ICType=Panel&Menu=UW_CO_STUDENTS&Market=GBL&PanelGroupName=UW_CO_APP_SUMMARY&RL=&target=main0&navc=4844"
#define kJobMineURL_JobDetailsPageBaseURL			@"https://jobmine.ccol.uwaterloo.ca/servlets/iclientservlet/SS/?Menu=UW_CO_STUDENTS&Component=UW_CO_JOBDTLS&Market=GBL&Page=UW_CO_STU_JOBDTLS&Action=U&target=Transfer20&UW_CO_JOB_ID=%@"
#define kJobMineURL_ResetTimeout					@"https://jobmine.ccol.uwaterloo.ca//servlets/iclientservlet/SS/servlets/iclientservlet/SS/?cmd=resettimeout"           

#pragma mark -
#pragma mark JobMine Specific Strings
#define kJobMineStrings_Employed                    @"Employed"
#define kJobMineStrings_Offer                       @"Offer"
#define kJobMineStrings_Ranked                      @"Ranked"
#define kJobMineStrings_Scheduled                   @"Scheduled"
#define kJobMineStrings_Selected                    @"Selected"
#define kJobMineStrings_Alternate                   @"Alternate"
#define kJobMineStrings_Pending                     @"Pending"
#define kJobMineStrings_Applied                     @"Applied"
#define kJobMineStrings_NotRanked                   @"Not Ranked"
#define kJobMineStrings_NotSelected                 @"Not Selected"
#define kJobMineStrings_ResetTimeoutSuccess         @"Timeout has been reset!"

#pragma mark -
#pragma mark User Default Keys

#define kKeyDefaultOptionsSetForRelease1			@"kKeyDefaultOptionsSetForRelease1"
#define kKeyOptions_ShowInfo						@"kKeyOptions_ShowInfo"
#define kKeyOptions_OptionsDidChange				@"kKeyOptions_OptionsDidChange"
#define kKeyOptions_SortCriteriaDidChange			@"kKeyOptions_SortCriteriaDidChange"
#define kOptions_SortCriteriaKey					@"kOptions_SortCriteriaKey"
#define kOptions_SortAscending						@"kOptions_SortAscending"

#pragma mark -
#pragma mark Options View Indexes/Keys

#define kOptionsViewTableCellRowIndex_ShowJobTitle				0
#define kOptionsViewTableCellRowIndex_ShowEmployer				1
#define kOptionsViewTableCellRowIndex_ShowUnit					2
#define kOptionsViewTableCellRowIndex_ShowNumberOfApps			3
#define kOptionsViewTableCellRowIndex_ShowJobStatus				4
#define kOptionsViewTableCellRowIndex_ShowTerm					5
#define kOptionsViewTableCellRowIndex_ShowLastDayToApply		6
#define kOptionsViewTableCellRowIndex_ShowJobID					7
#define kOptionsViewTableCellRowIndex_ShowInterviewers			8
#define kOptionsViewTableCellRowIndex_ShowInterviewRoom			9
#define kOptionsViewTableCellRowIndex_ShowRankByUser			10
#define kOptionsViewTableCellRowIndex_ShowRankByEmployer		11

#define kNumberOfShowInfoOptions								12

#pragma mark -