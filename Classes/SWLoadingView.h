//
//  SWLoadingView.h
//  Joblet
//
//  Created by Sandy Wu on 11-04-09.
//  Copyright 2011 Sandy Wu. All rights reserved.
//


@interface SWLoadingView : UIView {
	//IBOutlet UIView *loadingView;
	IBOutlet UILabel *textLabel;
}

//@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;

+ (SWLoadingView *)sharedInstance;
+ (void)show;
+ (void)showWithText:(NSString *)text;
+ (void)hide;

@end
