//
//  JobItem.m
//  Joblet
//
//  Created by Sandy Wu on 11-02-26.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "JobItem.h"


@implementation JobItem

@synthesize jobID, jobTitle, employer, unit, term, termCode, jobStatus, jobStatusCode, appStatus, appStatusCode, lastDayToApply, lastDayToApplyDate, numberOfApps;
@synthesize interviewers, interviewRoom;
@synthesize rankByUser, rankByEmployer;

- (id)init
{
	if (self = [super init])
	{
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
	return [NSString stringWithFormat:@"<%@ %p>{jobID: %@, jobTitle: %@, employer: %@, unit :%@, term: %@, termCode: %@, jobStatus: %@, jobStatusCode: %@, appStatus: %@, appStatusCode: %@, lastDayToApply: %@, lastDayToApplyDate: %@, numberOfApps: %@, interviewers: %@, interviewRoom: %@, rankByUser: %@, rankByEmployer: %@}",
			[self class], self, jobID, jobTitle, employer, unit, term, termCode, jobStatus, jobStatusCode, appStatus, appStatusCode, lastDayToApply, lastDayToApplyDate, 
			numberOfApps, interviewers, interviewRoom, rankByUser, rankByEmployer];
}


- (NSComparisonResult)compare:(JobItem *)other
{
	return [self.jobID isEqualToNumber:other.jobID];
}

@end
	