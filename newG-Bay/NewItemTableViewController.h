//
//  NewItemTableViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/4/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionPopoverViewController.h"
@interface NewItemTableViewController : UITableViewController <UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, popoverDelegate>
- (void)secondViewControllerDismissed:(NSString *)stringForFirst;
@property (weak, nonatomic)  NSString *myString;

@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *addPhotosButton;
- (IBAction)addPhotosAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitAction:(id)sender;
- (IBAction)changeCondition:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *conditionTextField;

@end
