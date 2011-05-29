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

#define kAppStatusCode_Employed                 0
#define kAppStatusCode_Offer                    1 // Not sure if this is valid, but just incase...
#define kAppStatusCode_Ranked                   2 // Not sure if this is valid, but just incase...
#define kAppStatusCode_PotentiallyRankedOrOffer 3 // If a jobItem's app status is blank, then it might be a Ranked or Offer. It has happened to me and some people, but I am not 100% sure that it will only be blank for Ranked/Offers. JobMine Plus (GreaseMonkey script) also does this as of this writing (May 29th, 2011).
#define kAppStatusCode_Scheduled                4
#define kAppStatusCode_Selected                 5
#define kAppStatusCode_Alternate                6
#define kAppStatusCode_Pending                  7
#define kAppStatusCode_Applied                  8
#define kAppStatusCode_NotRanked                9
#define kAppStatusCode_NotSelected              10
#define kAppStatusCode_CancelledJob             11 // If a jobItem's job status is "Cancelled", then when we sort by the app status we put it at the bottom regardless of application status
#define kAppStatusCode_Unknown                  12 // For any state that I missed and blank app statuses
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