//
//  UserJobDatabase.h
//  Joblet
//
//  Created by Sandy Wu on 11-03-01.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "JobItem.h"

@interface UserJobDatabase : NSObject {

}

// Database management
+ (void)initDatabase;
+ (void)userLoggedOut;
+ (NSMutableArray *)getJobIDList;

// Job Item management
+ (void)addJobItem:(JobItem *)item;
+ (JobItem *)getJobItemForJobID:(NSNumber *)key;
+ (NSMutableArray *)getJobItemArray;
+ (BOOL)dirtyJobList;
+ (void)setDirtyJobList:(BOOL)flag;

@end
