//
//  UserJobDatabase.m
//  Joblet
//
//  Created by Sandy Wu on 11-03-01.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "UserJobDatabase.h"

@implementation UserJobDatabase

static NSMutableArray *jobIDList = nil;
static NSMutableDictionary *jobItemLookup = nil;

static BOOL dirtyJobList = NO;

#pragma mark -
#pragma mark Database Management

+ (void)initDatabase
{
	if (jobIDList == nil)
		jobIDList = [[NSMutableArray alloc] initWithCapacity:20];
	
	if (jobItemLookup == nil)
		jobItemLookup = [[NSMutableDictionary alloc] initWithCapacity:20];
}

+ (void)userLoggedOut
{
	NSLog(@"Temp debug for user logout");
	NSLog(@"retain counts: %d, %d", [jobIDList retainCount], [jobItemLookup retainCount]);
	[jobIDList release], jobIDList = nil;
	[jobItemLookup release], jobItemLookup = nil;
	
	[UserJobDatabase initDatabase];
}

+ (NSMutableArray *)getJobIDList
{
	return jobIDList;
}

#pragma mark -
#pragma mark JobItem Data Management

+ (void)addJobItem:(JobItem *)item
{
	NSNumber *jobID = item.jobID;
	// We're assuming job IDs are unique, not sure if this assumption will hold
	if ([jobIDList containsObject:jobID])
	{
		// Update existing job details
		// Since we only fetch the applications page, we can safely overwrite the existing object.
		// Need to update the job per field when we start fetching data from multiple pages.
		NSLog(@"Database Debug: Updating to object:\n%@", item);
		[jobItemLookup setObject:item forKey:jobID];
	}
	else
	{
		// Add new job and details
		NSLog(@"Database Debug: Adding object:\n%@", item);
		[jobIDList addObject:jobID];
		[jobItemLookup setObject:item forKey:jobID];
	}
	[UserJobDatabase setDirtyJobList:YES];
}

+ (JobItem *)getJobItemForJobID:(NSNumber *)key
{
	return [jobItemLookup objectForKey:key];
}

+ (NSMutableArray *)getJobItemArray
{
	NSMutableArray *retArray = [[[NSMutableArray alloc] initWithCapacity:[jobItemLookup count]] autorelease];
	// We don't directly store our data in arrays because we may later want to implement a refresh feature.
	// Using a dictionary will allow us to easily locate the item we are updating.
	
	for (JobItem *item in [jobItemLookup allValues])
	{
		[retArray addObject:item];
	}
	
	return retArray;
}

+ (BOOL)dirtyJobList
{
	return dirtyJobList;
}

+ (void)setDirtyJobList:(BOOL)flag
{
	dirtyJobList = flag;
}

@end
