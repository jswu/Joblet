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

#define kAppStatusCode_Employed		0
#define kAppStatusCode_Offer		1 // Not sure if this is valid, but just incase...
#define kAppStatusCode_Ranked		2 // Not sure if this is valid, but just incase...
#define kAppStatusCode_NotRanked	3
#define kAppStatusCode_Selected		4 // TODO: Verify that the string is "Selected"
#define kAppStatusCode_Alternate	5
#define kAppStatusCode_Pending		6
#define kAppStatusCode_Applied		7
#define kAppStatusCode_NotSelected	8
#define kAppStatusCode_Unknown		9 // For any state that I missed and blank app statuses
// Blank states can sometimes mean "offer". One of my offers were blank, but others weren't...not sure why this happens

// Usnure of existance
#define kAppStatus_NotApplied	6
#define kAppStatus_Ranked		7



@interface JobItem : NSObject {
	// Applications page
	NSString	*jobIDString;
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
@property (nonatomic, copy) NSString	*jobIDString;
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

- (void)configureAppStatusCodeAndColour;

@end