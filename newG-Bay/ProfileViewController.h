//
//  ProfileViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/2/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
@import Firebase;
#import "SWBufferedToast/SWBufferedToast.h"

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;

@property (weak, nonatomic) IBOutlet UILabel *gbayBalanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenCount;
- (IBAction)submitAction:(id)sender;

@end
