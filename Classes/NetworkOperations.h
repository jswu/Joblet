//
//  NetworkOperations.h
//  Joblet
//
//  Created by Sandy Wu on 11-05-16.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@interface NetworkOperations : NSObject {

}

+ (BOOL)hasNetworkConnection;

+ (void)requestToLoginWithUserID:(NSString *)userID password:(NSString *)password callback:(SEL)method on:(id)target;
+ (void)requestToApplicationsWithCallback:(SEL)method on:(id)target;

/*
+ (void)requestToShortListWithCallBack:(SEL)method on:(id)target;
+ (void)requestToInterviewsWithCallback:(SEL)method on:(id)target;
*/

@end
