//
//  JobItem.m
//  Joblet
//
//  Created by Sandy Wu on 11-02-26.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "JobItem.h"


@implementation JobItem

@synthesize jobIDString, jobID, jobTitle, employer, unit, term, termCode, jobStatus, jobStatusCode, appStatus, appStatusCode, lastDayToApply, lastDayToApplyDate, numberOfApps;
@synthesize interviewers, interviewRoom;
@synthesize rankByUser, rankByEmployer;

- (id)init
{
	if (self = [super init])
	{
		jobIDString = nil;
		jobID = nil;
		
		jobTitle = nil;
		employer = nil;
		unit = nil;
		
		term = nil;
		termCode = nil;
		
		jobStatus = nil;
		jobStatusCode = nil;
		
		appStatus = nil;
		appStatusCode = nil;
		
		lastDayToApply = nil;
		lastDayToApplyDate = nil;
		
		numberOfApps = nil;
		
		interviewers = nil;
		interviewRoom = nil;
		
		rankByUser = nil;
		rankByEmployer = nil;
	}
	
	return self;
}

- (void)dealloc
{
	[jobIDString release], jobIDString = nil;
	[jobID release], jobID = nil;
	
	[jobTitle release], jobTitle = nil;
	[employer release], employer = nil;
	[unit release], unit = nil;
	
	[term release], term = nil;
	[termCode release], termCode = nil;
	
	[jobStatus release], jobStatus = nil;
	[jobStatusCode release], jobStatusCode = nil;
	
	[appStatus release], appStatus = nil;
	[appStatusCode release], appStatusCode = nil;
	
	[lastDayToApply release], lastDayToApply = nil;
	[lastDayToApplyDate release], lastDayToApplyDate = nil;
	
	[numberOfApps release], numberOfApps = nil;
	
	[interviewers release], interviewers = nil;
	[interviewRoom release], interviewRoom = nil;
	
	[rankByUser release], rankByUser = nil;
	[rankByEmployer release], rankByEmployer = nil;
	
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ %p>{jobIDString: %@, jobID: %@, jobTitle: %@, employer: %@, unit :%@, term: %@, termCode: %@, jobStatus: %@, jobStatusCode: %@, appStatus: %@, appStatusCode: %@, lastDayToApply: %@, lastDayToApplyDate: %@, numberOfApps: %@, interviewers: %@, interviewRoom: %@, rankByUser: %@, rankByEmployer: %@}",
			[self class], self, jobIDString, jobID, jobTitle, employer, unit, term, termCode, jobStatus, jobStatusCode, appStatus, appStatusCode, lastDayToApply, lastDayToApplyDate, 
			numberOfApps, interviewers, interviewRoom, rankByUser, rankByEmployer];
}


- (NSComparisonResult)compare:(JobItem *)other
{
	return [self.jobID isEqualToNumber:other.jobID];
}

- (void)configureAppStatusCodeAndColour
{
	int code;
	// TODO: Add a colour field for each job item depending on the application status
	// In the options they can make this apply only to the appStatus text or the whole bcakground. Or none at all (maybe?)
//	UIColor *colour;
	
	if ([appStatus isEqualToString:kJobMineStrings_Employed])
		code = kAppStatusCode_Employed;
	else if ([appStatus isEqualToString:kJobMineStrings_Offer])
		code = kAppStatusCode_Offer;
	else if ([appStatus isEqualToString:kJobMineStrings_Ranked])
		code = kAppStatusCode_Ranked;
	else if ([appStatus isEqualToString:@""])
		code = kAppStatusCode_PotentiallyRankedOrOffer;
	else if ([appStatus isEqualToString:kJobMineStrings_Scheduled])
		code = kAppStatusCode_Scheduled;
	else if ([appStatus isEqualToString:kJobMineStrings_Selected])
		code = kAppStatusCode_Selected;
	else if ([appStatus isEqualToString:kJobMineStrings_Alternate])
		code = kAppStatusCode_Alternate;
	else if ([appStatus isEqualToString:kJobMineStrings_Pending])
		code = kAppStatusCode_Pending;
	else if ([appStatus isEqualToString:kJobMineStrings_Applied])
		code = kAppStatusCode_Applied;
	else if ([appStatus isEqualToString:kJobMineStrings_NotRanked])
		code = kAppStatusCode_NotRanked;
	else if ([appStatus isEqualToString:kJobMineStrings_NotSelected])
		code = kAppStatusCode_NotSelected;
	else
		code = kAppStatusCode_Unknown;
	
    // When this method gets called, both the jobStatus and the appStatus should be populated
    // Cancelled jobs should be sorted to the bottom
    if ([jobStatus isEqualToString:kJobMineStrings_Cancelled])
    {
        code = kAppStatusCode_CancelledJob;
        // Change the appStatus string to reflect the cancelled state
        self.appStatus = [NSString stringWithFormat:@"Cancelled (%@)", appStatus];
    }
    
	[self setAppStatusCode:[NSNumber numberWithInt:code]];
}
@end
	