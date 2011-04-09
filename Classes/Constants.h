//
//  Constants.h
//  Joblet
//
//  Created by Sandy Wu on 11-04-03.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#pragma mark -
#pragma mark All strings in app shown to user

#define kString_GenericErrorMessage					NSLocalizedString(@"An unexpected error has occurred, please try again later\nError code: %@", @"Generic unknown error message")
#define kString_NoJobDetailsPageFound				NSLocalizedString(@"Job details page not found.", @"Job details page link could not be generated simce job ID was blank")

// Loading Message for SWLoadingView
#define kString_SW_Loading							NSLocalizedString(@"Loading...", @"Default loading message for the loading popup")

#pragma mark -
#pragma mark JobMine URLS

#define kJobMineURL_LoginForm						@"https://jobmine.ccol.uwaterloo.ca/servlets/iclientservlet/ES/?cmd=login&languageCd=ENG&sessionId="
#define kJobMineURL_ApplicationPage					@"https://jobmine.ccol.uwaterloo.ca/servlets/iclientservlet/ES/?ICType=Panel&Menu=UW_CO_STUDENTS&Market=GBL&PanelGroupName=UW_CO_APP_SUMMARY&RL=&target=main0&navc=4844"
#define kJobMineURL_JobDetailsPageBaseURL			@"https://jobmine.ccol.uwaterloo.ca/servlets/iclientservlet/SS/?Menu=UW_CO_STUDENTS&Component=UW_CO_JOBDTLS&Market=GBL&Page=UW_CO_STU_JOBDTLS&Action=U&target=Transfer20&UW_CO_JOB_ID=%@"

#pragma mark -