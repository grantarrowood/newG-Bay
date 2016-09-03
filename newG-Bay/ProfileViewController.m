//
//  ProfileViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/2/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
{
    FIRDatabaseHandle _refHandle;
    NSString *feedbackPositive;
    NSString *feedbackNegative;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];

    
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/users"];
    _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        NSString *key = [NSString stringWithFormat:@"%@",[FIRAuth auth].currentUser.uid];
        if ([snapshot.key isEqualToString: key]) {
            [_objects addObject:snapshot];
            NSDictionary<NSString *, NSString *> *object = snapshot.value;
            feedbackPositive = object[@"feedbackPositive"];
            feedbackNegative = object[@"feedbackNegative"];
            NSString *tokenCount = object[@"tokenCount"];
            NSString *gbayBalance = object[@"Gbalance"];
            NSString *firstName = object[@"firstName"];
            NSString *username = object[@"userName"];

            float feedbackFloat = (feedbackPositive.intValue + feedbackNegative.intValue);
            float feedbackPercent = ((feedbackPositive.intValue)/feedbackFloat)*100;
            self.tokenCount.text = tokenCount;
            self.feedbackLabel.text = [NSString stringWithFormat:@"Positive: %@ Negative: %@ Precent: %.0f%%", feedbackPositive, feedbackNegative, feedbackPercent];
            self.gbayBalanceLabel.text = gbayBalance;
            self.firstNameTextField.text = firstName;
            self.usernameTextField.text = username;
            
            
            FIRUser *user = [FIRAuth auth].currentUser;
            NSString *email = user.email;
            self.emailTextField.text = email;
            
        } else {
            
        }

    }];

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitAction:(id)sender {
    SWBufferedToast *noticeToast = [[SWBufferedToast alloc] initNoticeToastWithTitle:@"Loading"
                                                                            subtitle:@"Please wait while loading data!"
                                                                       timeToDisplay:120
                                                                    backgroundColour:nil
                                                                          toastColor:self.candyCaneRed
                                                                 animationImageNames:nil
                                                                              onView:self.view];
    [noticeToast appear];
    
    //Show the buffering state. You can supply your own images for the animation; if you don't a default animation will be used.
    [noticeToast beginLoading];
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [self addObject:@{@"Gbalance":self.gbayBalanceLabel.text, @"feedbackNegative":feedbackNegative, @"feedbackPositive": feedbackPositive, @"firstName": self.firstNameTextField.text, @"tokenCount": self.tokenCount.text, @"userName": self.usernameTextField.text}];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // when your application opens:
        //                NSString * viewIdentifierString = [[NSUserDefaults standardUserDefaults]
        //                                                   stringForKey:@"last_view"];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                                 withSlideOutAnimation:NO
                                                                         andCompletion:nil];
        [noticeToast endLoading];
    } else {
        [self addObject:@{@"Gbalance":self.gbayBalanceLabel.text, @"feedbackNegative":feedbackNegative, @"feedbackPositive": feedbackPositive, @"firstName": self.firstNameTextField.text, @"tokenCount": self.tokenCount.text, @"userName": self.usernameTextField.text}];
        FIRUser *user = [FIRAuth auth].currentUser;
        
        [user updateEmail:self.emailTextField.text completion:^(NSError *_Nullable error) {
            if (error) {
                // An error happened.
            } else {
                // Email updated.
            }
        }];
        [user updatePassword:self.passwordTextField.text completion:^(NSError *_Nullable error) {
            if (error) {
                // An error happened.
            } else {
                // Password updated.
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                // when your application opens:
//                NSString * viewIdentifierString = [[NSUserDefaults standardUserDefaults]
//                                                   stringForKey:@"last_view"];
                UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                                         withSlideOutAnimation:NO
                                                                                 andCompletion:nil];
                [noticeToast endLoading];
            }
        }];
    }
    
    
    
}

- (void)addObject:(NSDictionary *)data {
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/users"];
    [[ref child:[FIRAuth auth].currentUser.uid] setValue:mdata];
}


#pragma mark - nice colours.
- (UIColor *)eggshellGreen
{
    return [UIColor colorWithRed:114.0f/255.0f green:209.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

- (UIColor *)ectoplasmGreen
{
    //Mmmmmm, tastes like spooks.
    return [UIColor colorWithRed:114.0f/255.0f green:209.0f/255.0f blue:192.0f/255.0f alpha:0.75f];
}

- (UIColor *)candyCaneRed
{
    return [UIColor colorWithRed:211.0f/255.0f green:59.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
}

- (UIColor *)jarringBlue
{
    return [UIColor colorWithRed:0.0f/255.0f green:176.0f/255.0f blue:193.0f/255.0f alpha:0.75f];
}



@end
