//
//  HelperFunction.h
//  Joblet
//
//  Created by Sandy Wu on 11-04-03.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HelperFunction : NSObject {

}

+ (void)showErrorAlertMsg:(NSString *)msg;
+ (void)showAlertCheckConnection;
+ (void)showAlertMsg:(NSString *)msg withTitle:(NSString *)title;

@end
