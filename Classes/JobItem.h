//
//  JobItem.h
//  Joblet
//
//  Created by Sandy Wu on 11-02-26.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#define kSeason_Winter			0
#define kSeason_Spring			1
#define kSeason_Fall			2
#define kNumberOfSeasons		3

#define kJobStatus_Unfilled		0
#define kJobStatus_Filled		1
#define kJobStatus_Cancelled	2

#define kAppStatus_Applied		0
#define kAppStatus_NotSelected	1
#define kAppStatus_Pending		2
#define kAppStatus_NotRanked	3
#define kAppStatus_Alternate	4
#define kAppStatus_Employed		5

// Usnure of existance
#define kAppStatus_NotApplied	6
#define kAppStatus_Ranked		7



@interface JobItem : NSObject {
	// Applications page
	NSNumber	*jobIDString;
	NSNumber	*jobID;
	
	NSString	*jobTitle;
	NSString	*employer;
	NSString	*unit;
	
	NSString	*term;
	NSNumber	*termCode;
	
	NSString	*jobStatus;
	NSNumber	*jobStatusCode;
	
	NSString	*appStatus;
	NSNumber	*appStatusCode;
	
	NSString	*lastDayToApply;
	NSDate		*lastDayToApplyDate;
	
	NSNumber	*numberOfApps;
	
	// Interviews page
	NSString	*interviewers;
	NSString	*interviewRoom;
	
	// Rankings pages
	NSNumber	*rankByUser;
	NSNumber	*rankByEmployer;
	
}
// Applcations page
@property (nonatomic, copy) NSNumber	*jobIDString;
@property (nonatomic, retain) NSNumber	*jobID;

@property (nonatomic, copy) NSString	*jobTitle;
@property (nonatomic, copy) NSString	*employer;
@property (nonatomic, copy) NSString	*unit;

@property (nonatomic, copy) NSString	*term;
@property (nonatomic, retain) NSNumber	*termCode;

@property (nonatomic, copy) NSString	*jobStatus;
@property (nonatomic, retain) NSNumber	*jobStatusCode;

@property (nonatomic, copy) NSString	*appStatus;
@property (nonatomic, retain) NSNumber	*appStatusCode;

@property (nonatomic, copy) NSString	*lastDayToApply;
@property (nonatomic, retain) NSDate	*lastDayToApplyDate;

@property (nonatomic, retain) NSNumber	*numberOfApps;

// Interviews page
@property (nonatomic, copy) NSString	*interviewers;
@property (nonatomic, copy) NSString	*interviewRoom;

// Rankings page
@property (nonatomic, copy) NSNumber	*rankByUser;
@property (nonatomic, copy) NSNumber	*rankByEmployer;

@end