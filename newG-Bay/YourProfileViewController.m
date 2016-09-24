//
//  YourProfileViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/19/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//
#import "YourProfileViewController.h"
#import "LeftMenuViewController.h"
#import "UIImage+JVMenuCategory.h"
#import <Social/Social.h>


@interface YourProfileViewController () {
    NSArray* stateArray;
    NSString* popoverIdentifier;
    FIRDatabaseHandle _refHandle;
    NSString *email;
    NSString *username;
    NSString *firstName;
    NSString *lastName;
    NSString *street;
    NSString *city;
    NSString *state;
    int gbayBalance;
    int tokenFound;
    int tokensAvalible;
    int feedbackNegative;
    int feedbackPositive;
}

@end

@implementation YourProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Your Profile";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"app_bg1.jpg"] imageScaledToWidth:self.view.frame.size.width]];
    _objects = [[NSMutableArray alloc] init];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/users"];
    _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        NSString *key = [NSString stringWithFormat:@"%@",[FIRAuth auth].currentUser.uid];
        if ([snapshot.key isEqualToString: key]) {
            [_objects addObject:snapshot];
            NSDictionary<NSString *, NSString *> *object = snapshot.value;
            feedbackPositive = object[@"feedbackPositive"].intValue;
            feedbackNegative = object[@"feedbackNegative"].intValue;
            tokenFound = object[@"tokenFound"].intValue;
            tokensAvalible = object[@"tokenAvaliable"].intValue;
            gbayBalance = object[@"Gbalance"].intValue;
            firstName = object[@"firstName"];
            username = object[@"userName"];
            lastName = object[@"lastName"];
            float locationLat = object[@"locationLat"].floatValue;
            float locationLon = object[@"locationLon"].floatValue;
            CLLocation *location = [[CLLocation alloc]
                                    initWithLatitude:locationLat
                                    longitude:locationLon];
            
            CLGeocoder* geocoder = [[CLGeocoder alloc] init];
            [geocoder
             reverseGeocodeLocation:location
             completionHandler:^(NSArray *placemarks, NSError *error) {
                 
                 CLPlacemark *placemark = [placemarks lastObject];
                 NSString *address = [NSString stringWithFormat:@"%@ %@ %@, %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea];
                 street = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
                 city = placemark.locality;
                 state = placemark.administrativeArea;
                 
             }];
            FIRUser *user = [FIRAuth auth].currentUser;
            email = user.email;
            [self.stackFormView addSections:[self sectionsForStackFormView:self.stackFormView]];
        } else {
            
        }
        
    }];
    self.storageRef = [[FIRStorage storage] referenceForURL:@"gs://g-bay-70b9c.appspot.com"];
    stateArray = [[NSArray alloc] initWithObjects:@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray <INSStackFormSection *> *)sectionsForStackFormView:(INSStackFormView *)stackViewFormView {
    NSMutableArray *sections = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [sections addObject:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        sectionBuilder.identifier = @"ItemDetails";
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"General";
            builder.height = @56;
            builder.actionBlock = nil;
            builder.identifier = @"General";
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.title = @"First Name";
            builder.identifier = @"FirstName";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                //view.textField.placeholder = @"First Name";
                view.textField.text = firstName;
                [self.stackFormView firstItemWithIdentifier:@"FirstName"].value = firstName;
                
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.title = @"Last Name";
            builder.identifier = @"LastName";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Last Name";
                view.textField.text = lastName;
                [self.stackFormView firstItemWithIdentifier:@"LastName"].value = lastName;

            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.title = @"Username";
            builder.identifier = @"Username";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Username";
                view.textField.text = username;
                [self.stackFormView firstItemWithIdentifier:@"Username"].value = username;

            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.title = @"Email";
            builder.identifier = @"Email";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Email";
                view.textField.text =  email;
                [self.stackFormView firstItemWithIdentifier:@"Email"].value = email;
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.title = @"Password";
            builder.identifier = @"Password";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Password";
                view.textField.secureTextEntry = true;
                
                
            };
        }];
        
    }]];
    
    //**********************************************************************************************************************
    
    
    
    
    [sections addObject:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        sectionBuilder.identifier = @"Address";
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Address Info";
            builder.height = @56;
            builder.userInteractionEnabled = NO;
            builder.actionBlock = nil;
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.title = @"Street";
            builder.identifier = @"Street";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Street";
                view.textField.text = street;
                [self.stackFormView firstItemWithIdentifier:@"Street"].value = street;
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.identifier = @"City";
            builder.title = @"City";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"City";
                view.textField.text = city;

                [self.stackFormView firstItemWithIdentifier:@"City"].value = city;
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = [NSString stringWithFormat:@"State: %@", state];
            builder.identifier = @"State";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                popoverIdentifier = @"State";
                [SlideNavigationController sharedInstance].leftMenu.view.alpha = 0;
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.view addSubview:self.containerView];
                
                // creating menu
                self.menuPopover = [self menuPopover:stateArray];
                
                [self addObservers];
                
                [self showMenu];
            };
        }];
        
    }]];
    
    [sections addObject:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        sectionBuilder.identifier = @"Tokens";
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Tokens";
            builder.height = @56;
            builder.userInteractionEnabled = NO;
            builder.actionBlock = nil;
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = [NSString stringWithFormat:@"Found Tokens: %d", tokenFound];
            builder.identifier = @"FoundTokens";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
            };
        }];
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = [NSString stringWithFormat:@"Avaliable Tokens: %d", tokensAvalible];
            builder.identifier = @"AvaliableTokens";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
            };
        }];
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = [NSString stringWithFormat:@"G-Bucks: %d", gbayBalance];
            builder.identifier = @"gbucks";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
        }];
        
    }]];
    
    
    [sections addObject:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        sectionBuilder.identifier = @"Feedback";
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Feedback";
            builder.height = @56;
            builder.userInteractionEnabled = NO;
            builder.actionBlock = nil;
        }];
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = [NSString stringWithFormat:@"Positive Feedback: %d", feedbackPositive];
            builder.identifier = @"PositiveFeedback";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                //Create action where drpos down and shows first 10 positive feedbacks... and show all button
            };
        }];
        
        
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = [NSString stringWithFormat:@"Negative Feedback: %d", feedbackNegative];
            builder.identifier = @"NegativeFeedback";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                //Create action where drpos down and shows first 10 positive feedbacks... and show all button
            };
        }];
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Most Recent Feedback:";
            builder.identifier = @"RecentFeedback";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                //Create action where drpos down and shows first 10 positive feedbacks... and show all button
            };
        }];
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Send Feedback";
            builder.identifier = @"SendFeedback";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                //Open Send Feedback View Controller
            };
        }];
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Bought Items";
            builder.identifier = @"BoughtItems";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                //Open Bought Items View Controller
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"BoughtItemsTableViewController"];
                
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                                         withSlideOutAnimation:NO
                                                                                 andCompletion:nil];
            };
        }];
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Sold Items";
            builder.identifier = @"SoldItems";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
                [view.contentView addConstraint:[NSLayoutConstraint constraintWithItem:view.textLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:view.contentView
                                                                             attribute:NSLayoutAttributeLeft
                                                                            multiplier:1.f constant:10.f]];
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                //Open Sold Items View Controller
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SoldItemsTableViewController"];
                
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                                         withSlideOutAnimation:NO
                                                                                 andCompletion:nil];
            };
        }];
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Submit!!!";
            builder.height = @50;
            builder.actionBlock = ^(INSStackFormViewBaseElement *view) {
                NSArray *errors = nil;
                if (![view.stackFormView validateSection:view.section errorMessages:&errors]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[errors firstObject] preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    NSLog(@"%@", self.categoryString);
                } else {
                    //DO SUCCESS STUFF HERE
                    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
                    [geocoder geocodeAddressString:[view.stackFormView firstItemWithIdentifier:@"Street"].value
                                 completionHandler:^(NSArray* placemarks, NSError* error){
                                     for (CLPlacemark* aPlacemark in placemarks)
                                     {
                                         // Process the placemark.
                                         CLLocation *loc = aPlacemark.location;
                                         NSLog(@"View Controller get Location Logitute : %f",loc.coordinate.latitude);
                                         NSLog(@"View Controller get Location Latitute : %f",loc.coordinate.longitude);
                                         // Get objects then
                                         
                                         if (![view.stackFormView firstItemWithIdentifier:@"Password"].value) {
                                             [self addObject:@{@"Gbalance":[NSString stringWithFormat:@"%d", gbayBalance], @"feedbackNegative":[NSString stringWithFormat:@"%d", feedbackNegative], @"feedbackPositive": [NSString stringWithFormat:@"%d", feedbackPositive], @"firstName": [view.stackFormView firstItemWithIdentifier:@"FirstName"].value, @"lastName": [view.stackFormView firstItemWithIdentifier:@"LastName"].value , @"tokenFound": [NSString stringWithFormat:@"%d", tokenFound], @"userName": [view.stackFormView firstItemWithIdentifier:@"Username"].value, @"tokenAvaliable": [NSString stringWithFormat:@"%d", tokensAvalible], @"locationLat": [NSString stringWithFormat:@"%f", loc.coordinate.latitude], @"locationLon": [NSString stringWithFormat:@"%f", loc.coordinate.longitude]}];
                                             // when your application opens:
                                             //                NSString * viewIdentifierString = [[NSUserDefaults standardUserDefaults]
                                             //                                                   stringForKey:@"last_view"];
                                         } else {
                                             [self addObject:@{@"Gbalance":[NSString stringWithFormat:@"%d", gbayBalance], @"feedbackNegative":[NSString stringWithFormat:@"%d", feedbackNegative], @"feedbackPositive": [NSString stringWithFormat:@"%d", feedbackPositive], @"firstName": [view.stackFormView firstItemWithIdentifier:@"firstName"].value, @"lastName": [view.stackFormView firstItemWithIdentifier:@"lastName"].value , @"tokenFound": [NSString stringWithFormat:@"%d", tokenFound], @"userName": [view.stackFormView firstItemWithIdentifier:@"Username"].value, @"tokenAvaliable": [NSString stringWithFormat:@"%d", tokensAvalible]}];
                                             FIRUser *user = [FIRAuth auth].currentUser;
                                             
                                             [user updateEmail:[view.stackFormView firstItemWithIdentifier:@"Email"].value completion:^(NSError *_Nullable error) {
                                                 if (error) {
                                                     // An error happened.
                                                 } else {
                                                     // Email updated.
                                                 }
                                             }];
                                             [user updatePassword:[view.stackFormView firstItemWithIdentifier:@"Password"].value completion:^(NSError *_Nullable error) {
                                                 if (error) {
                                                     // An error happened.
                                                 } else {
                                                     // Password updated.
                                                 }
                                             }];
                                         }
                                     }
                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                     UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                                     
                                     [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                                                              withSlideOutAnimation:NO
                                                                                                      andCompletion:nil];
                                 }];
                }
            };
            builder.validationBlock = ^BOOL(__kindof INSStackFormViewBaseElement *view, INSStackFormItem *item, NSString **errorMessage) {
                if (![view.stackFormView firstItemWithIdentifier:@"FirstName"].value) {
                    *errorMessage = @"First Name can't be nil.";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"LastName"].value) {
                    *errorMessage = @"Last Name Costs can't be nil";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"Username"].value) {
                    *errorMessage = @"Username Service can't be nil";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"Email"].value) {
                    *errorMessage = @"Email can't be nil";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"Street"].value) {
                    *errorMessage = @"Street can't be nil.";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"City"].value) {
                    *errorMessage = @"City can't be nil";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"State"].value) {
                    *errorMessage = @"State can't be nil";
                    return NO;
                }
                return YES;
            };
        }];
        
        
    }]];
    
    return sections;
}

- (void)addObject:(NSDictionary *)data{
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/users"];
    [[ref child:[FIRAuth auth].currentUser.uid] setValue:mdata];
}




- (YourProfileViewController *)rootController
{
    if (!_rootController)
    {
        _rootController = [[YourProfileViewController alloc] init];
    }
    
    return _rootController;
}


- (JVMenuItems *)menuItems:(NSArray *)menuTitles
{
    if(!_menuItems)
    {
        _menuItems = [[JVMenuItems alloc] initWithMenuImages:nil
                                                  menuTitles:menuTitles
                                        menuCloseButtonImage:[UIImage imageNamed:@"cancel_filled-50"]];
        _menuItems.menuSlideInAnimation = YES;
    }
    
    return _menuItems;
}


- (JVMenuPopoverView *)menuPopover:(NSArray *)menuTitles
{
    if(!_menuPopover)
    {
        _menuPopover = [[JVMenuPopoverView alloc] initWithFrame:self.view.frame menuItems:[self menuItems:menuTitles]];
        _menuPopover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _menuPopover.delegate = self;
    }
    
    return _menuPopover;
}


- (UIView *)containerView
{
    if (!_containerView)
    {
        _containerView = [[UIView alloc] initWithFrame:self.containerViewFrame];
    }
    
    return _containerView;
}


- (CGRect)containerViewFrame
{
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


#pragma mark - Menu Helper Functions

- (void)showMenu
{
    [self.menuPopover showMenuWithController:self];
}


#pragma mark - Menu Delegate

- (void)menuPopoverDidSelectViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [SlideNavigationController sharedInstance].leftMenu.view.alpha = 1;
    [self.containerView removeFromSuperview];
    self.menuPopover = nil;
    self.menuItems = nil;
    if ([popoverIdentifier isEqualToString:@"State"]) {
        [self.stackFormView firstItemWithIdentifier:@"State"].value = stateArray[indexPath.row];
        [self.stackFormView firstItemWithIdentifier:@"State"].title = [NSString stringWithFormat:@"State: %@",stateArray[indexPath.row]];
        [self.stackFormView refreshItems:@[[self.stackFormView firstItemWithIdentifier:@"State"]]];
    }
}

- (void)menuPopoverViewWillShow
{
    [self.view endEditing:YES];
}


- (void)menuPopoverViewWillHide
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [SlideNavigationController sharedInstance].leftMenu.view.alpha = 1;
    [self.containerView removeFromSuperview];
    self.menuItems = nil;
    self.menuPopover = nil;
}


#pragma mark - Observers

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}


- (void)didDeviceOrientationChange:(NSNotification *)notification
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    self.containerView.frame = self.containerViewFrame;
    UIColor *firstColor = [UIColor colorWithHexString:@"52EDC7"];
    UIColor *secondColor = [UIColor colorWithHexString:@"5AC8FB"];
    [self.containerView gradientEffectWithFirstColor:firstColor secondColor:secondColor];
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (!self.menuPopover.isHidden)
    {
        [self.menuPopover closeMenu];
    }
}

@end
