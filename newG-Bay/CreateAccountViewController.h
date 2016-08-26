//
//  CreateAccountViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 8/21/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface CreateAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)createAction:(id)sender;

@end
