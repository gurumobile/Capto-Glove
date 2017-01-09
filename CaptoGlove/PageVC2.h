//
//  PageVC2.h
//  CaptoGlove
//
//  Created by Georgi on 12/26/16.
//  Copyright © 2016 georgi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"

@interface PageVC2 : UIViewController <TPFloatRatingViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *captoRatingLbl;
@property (weak, nonatomic) IBOutlet UILabel *materialRatingLbl;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextview;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (weak, nonatomic) IBOutlet TPFloatRatingView *captoView;
@property (weak, nonatomic) IBOutlet TPFloatRatingView *materialView;

@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UIView *thanksView;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *company;

- (IBAction)onFinish:(id)sender;

@end
