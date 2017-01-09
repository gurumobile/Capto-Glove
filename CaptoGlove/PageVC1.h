//
//  PageVC1.h
//  CaptoGlove
//
//  Created by Georgi on 12/26/16.
//  Copyright © 2016 georgi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageVC1 : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)onNext:(id)sender;

@end
