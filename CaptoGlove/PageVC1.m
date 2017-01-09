//
//  PageVC1.m
//  CaptoGlove
//
//  Created by Georgi on 12/26/16.
//  Copyright © 2016 georgi. All rights reserved.
//

#import "PageVC1.h"
#import "PageVC2.h"

@interface PageVC1 ()

@end

@implementation PageVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.nextBtn.layer.cornerRadius = self.nextBtn.frame.size.height / 2;
    self.nextBtn.layer.borderWidth = 1.0;
    self.nextBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.nextBtn.layer.shadowOpacity = 0.7;
    self.nextBtn.layer.shadowRadius = 5.0;
}

- (IBAction)onNext:(id)sender {
    [self performSegueWithIdentifier:@"toFeedback" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PageVC2 *destVC = segue.destinationViewController;
    
    destVC.firstName = self.firstNameField.text;
    destVC.lastName = self.lastNameField.text;
    destVC.email = self.emailField.text;
    destVC.company = self.companyField.text;
}

#pragma mark -
#pragma mark - Unwind Segue...

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
}

@end
