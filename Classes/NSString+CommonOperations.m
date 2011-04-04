//
//  NSString+CommonOperations.m
//  Joblet
//
//  Created by Sandy Wu on 11-03-01.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import "NSString+CommonOperations.h"


@implementation NSString (CommonOperations)

- (NSString *)stringAfterTrim
{
	return [self stringByTrimmingCharactersInSet:
			[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
			
@end
