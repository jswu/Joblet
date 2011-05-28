//
//  JobletViewController.h
//  Joblet
//
//  Created by Sandy Wu on 11-01-10.
//  Copyright 2011 Sandy Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define kTag_LoginRequest	0

#define kErrorCode_BlankLoginResponse	@"100"
#define	kErrorCode_NullLoginHTMLDoc		@"101"
#define	kErrorCode_NullLoginHTMLNode	@"102"
 
@interface JobletViewController : UIViewController<ASIHTTPRequestDelegate> {
	IBOutlet UITextField *userID;
	IBOutlet UITextField *password;
	IBOutlet UISegmentedControl *loginButton;
	IBOutlet UILabel *userMessages;
    IBOutlet UISwitch *rememberMeSwitch;
    
	NSString *tempUserID;
	NSString *tempPassword;
	
	ASIFormDataRequest *formRequest;
}

@property (nonatomic, retain) IBOutlet UITextField *userID;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UISegmentedControl *loginButton;
@property (nonatomic, retain) IBOutlet UILabel *userMessages;
@property (nonatomic, retain) IBOutlet UISwitch *rememberMeSwitch;
@property (nonatomic, copy) NSString *tempUserID;
@property (nonatomic, copy) NSString *tempPassword;
@property (nonatomic, retain) ASIFormDataRequest *formRequest;

- (IBAction)userIDDoneEditing:(id)sender;
- (IBAction)passwordDoneEditing:(id)sender;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

- (IBAction)rememberMeSwitchToggled:(id)sender;

- (void)fetchApplicationPage:(NSArray *)params;

- (void)loginPageRequestCallback:(NSString *)response;

@end

