//
//  NewerItemViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/5/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "NewerItemViewController.h"
#import "LeftMenuViewController.h"
#import "UIImage+JVMenuCategory.h"
#import <Social/Social.h>


@interface NewerItemViewController () <subViewDelegate> {
    NSURL *imageFile;
    NSString *filePath;
    NSData* pictureData;
    NSArray* photoArray;
    NSArray* conditionArray;
    NSArray* stateArray;
    NSArray* paymentMethodArray;
    NSArray* handlingTimeArray;
    NSArray* returnsArray;
    NSArray* deliveryTypeArray;
    NSArray* shippingServiceArray;
    NSString* popoverIdentifier;
    BOOL didAdd;
    int photoLines;
}

@end

@implementation NewerItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create New Item";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"app_bg1.jpg"] imageScaledToWidth:self.view.frame.size.width]];
    _objects = [[NSMutableArray alloc] init];
    photoArray = [[NSArray alloc] init];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [_objects addObject:snapshot];
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    self.storageRef = [[FIRStorage storage] referenceForURL:@"gs://g-bay-70b9c.appspot.com"];
    [self.stackFormView addSections:[self sectionsForStackFormView:self.stackFormView]];
    conditionArray = [[NSArray alloc] initWithObjects:@"New", @"Like New", @"Very Good", @"Good", @"Acceptable", nil];
    stateArray = [[NSArray alloc] initWithObjects:@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
    
    paymentMethodArray = [[NSArray alloc] initWithObjects:@"PayPal", @"Visa/MasterCard", @"Discover", @"American Express", @"Cash", nil];
    handlingTimeArray = [[NSArray alloc] initWithObjects:@"1 Buisness Day", @"2 Buisness Days", @"3 Buisness Days", @"5 Buisness Days", @"7 Buisness Days", @"10 Buisness Days", @"15 Buisness Days", @"20 Buisness Days", @"30 Buisness Days", nil];
    
    returnsArray = [[NSArray alloc] initWithObjects:@"Accepted", @"Denied", nil];
    deliveryTypeArray = [[NSArray alloc] initWithObjects:@"Shipping", @"Local Pickup", nil];
    shippingServiceArray = [[NSArray alloc] initWithObjects:@"Expedited (1 to 4 Buisness Days)", @"Standard (2 to 6 Buisness Days)", @"Economy (2 to 9 Buisness Days)", @"None", nil];
    
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
            builder.title = @"Item Details";
            builder.height = @56;
            builder.actionBlock = nil;
            builder.identifier = @"Details";
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.title = @"Item Name";
            builder.identifier = @"ItemName";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Item Name";
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextViewElement class];
            builder.title = @"Description";
            builder.identifier = @"Description";
            builder.subtitle = nil;
            builder.height = @130;
            builder.configurationBlock = ^(INSStackFormViewTextViewElement *view) {
                view.textView.text = @"Description";
                view.textView.textColor = [UIColor lightGrayColor];
                
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.identifier = @"Price";
            builder.title = @"Price";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Price";
                view.textField.keyboardType = UIKeyboardTypeNumberPad;
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Condition:";
            builder.identifier = @"Condition";
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
                popoverIdentifier = @"Condition";
                [SlideNavigationController sharedInstance].leftMenu.view.alpha = 0;
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.view addSubview:self.containerView];
                // creating menu
                self.menuPopover = [self menuPopover:conditionArray];
                
                [self addObservers];
                
                [self showMenu];
                
            };
        }];
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewBaseElement class];
            builder.height = @240;
            builder.identifier = @"Categories";
            builder.configurationBlock = ^(INSStackFormViewBaseElement *view) {
                NSArray *tagsToDisplay = [[NSArray alloc] initWithObjects:@"Books", @"Business", @"Catalogues", @"Education", @"Finance", @"Food & Drink", @"Games",@"Health & Fitness", @"Kids", @"Lifestyle", @"Medical", @"Music", @"Navigation", @"News", @"Magazines & Newspapers", @"Photo & Video", @"Productivity",@"Reference", @"Shopping", @"Social Networking", @"Sports", @"Travel",@"Utilities", @"Weather", nil];
                ANTagsView *tagsView = [[ANTagsView alloc] initWithTags:tagsToDisplay frame:CGRectMake(0, 0, 10, 10)];
                [tagsView setTagCornerRadius:8];
                [tagsView setTagBackgroundColor:[UIColor grayColor]];
                [tagsView setTagTextColor:[UIColor whiteColor]];
                [tagsView setBackgroundColor:[UIColor clearColor]];
                [tagsView setFrameWidth:350];
                tagsView.delegate = self;
                [view addSubview:tagsView];
                view.accesoryType = INSStackFormViewBaseElementAccessoryNone;
            };
            builder.actionBlock = nil;
        }];
        
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"ADD PHOTOS";
            builder.identifier = @"AddPhotos";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                didAdd = false;
                self.imagePicker = [[UIImagePickerController alloc] init];
                self.imagePicker.delegate = self;
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            };
        }];
        
        
        
    }]];
    
    
    
    
    //********************************************************************************************************************************
    
    
    
    
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
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"State:";
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
    
    
    //********************************************************************************************************************************
    
    
    
    
    [sections addObject:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        sectionBuilder.identifier = @"Preferences";
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Preferences";
            builder.height = @56;
            builder.userInteractionEnabled = NO;
            builder.actionBlock = nil;
        }];
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Payment Method:";
            builder.identifier = @"PaymentMethod";
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
                popoverIdentifier = @"PaymentMethod";
                [SlideNavigationController sharedInstance].leftMenu.view.alpha = 0;
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.view addSubview:self.containerView];
                
                // creating menu
                self.menuPopover = [self menuPopover:paymentMethodArray];
                
                [self addObservers];
                
                [self showMenu];
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Handling Time:";
            builder.identifier = @"HandlingTime";
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
                popoverIdentifier = @"HandlingTime";
                [SlideNavigationController sharedInstance].leftMenu.view.alpha = 0;
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.view addSubview:self.containerView];
                
                // creating menu
                self.menuPopover = [self menuPopover:handlingTimeArray];
                
                [self addObservers];
                
                [self showMenu];
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Returns:";
            builder.identifier = @"Returns";
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
                popoverIdentifier = @"Returns";
                [SlideNavigationController sharedInstance].leftMenu.view.alpha = 0;
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.view addSubview:self.containerView];
                
                // creating menu
                self.menuPopover = [self menuPopover:returnsArray];
                
                [self addObservers];
                
                [self showMenu];
            };
        }];
        
    }]];
    
    
    //********************************************************************************************************************************
    
    
    
    
    [sections addObject:[INSStackFormSection sectionWithBuilder:^(INSStackFormSection *sectionBuilder) {
        sectionBuilder.showItemSeparators = YES;
        sectionBuilder.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
        sectionBuilder.identifier = @"DeliveryTypes";
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Delivery Type";
            builder.height = @56;
            builder.userInteractionEnabled = NO;
            builder.actionBlock = nil;
        }];
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Type of Delivery:";
            builder.identifier = @"DeliveryType";
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
                popoverIdentifier = @"DeliveryType";
                [SlideNavigationController sharedInstance].leftMenu.view.alpha = 0;
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.view addSubview:self.containerView];
                
                // creating menu
                self.menuPopover = [self menuPopover:deliveryTypeArray];
                
                [self addObservers];
                
                [self showMenu];
            };
        }];
        
        
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.identifier = @"ShippingCosts";
            builder.title = @"Shipping/Handling Costs";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Shipping/Handling Costs";
                view.textField.keyboardType = UIKeyboardTypeNumberPad;
            };
        }];
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Shipping Service:";
            builder.identifier = @"ShippingService";
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
                popoverIdentifier = @"ShippingService";
                [SlideNavigationController sharedInstance].leftMenu.view.alpha = 0;
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.view addSubview:self.containerView];
                
                // creating menu
                self.menuPopover = [self menuPopover:shippingServiceArray];
                
                [self addObservers];
                
                [self showMenu];
            };
        }];
        
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Post to Facebook";
            builder.identifier = @"Facebook";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                [self.view endEditing:YES];
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [controller setInitialText:[NSString stringWithFormat:@"Check out %@ on G-Bay!", [view.stackFormView firstItemWithIdentifier:@"ItemName"].value]];
                if (photoArray.count == 0) {
                    [controller addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://irs2.4sqi.net/img/general/500x500/2514_BvEN_Q6lG50xZQ9TIG0XY8eYXzF3USSMdtTmxHCmqnE.jpg"]]]];
                } else {
                    [controller addImage:photoArray[0]];
                }
                [self presentViewController:controller animated:YES completion:Nil];
            };
        }];

        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewLabelElement class];
            builder.title = @"Post to Twitter";
            builder.identifier = @"Twitter";
            builder.height = @56;
            builder.configurationBlock = ^(INSStackFormViewLabelElement *view) {
            };
            builder.actionBlock = ^(INSStackFormViewTextFieldElement *view) {
                NSLog(@"Action");
                [self.view endEditing:YES];
                SLComposeViewController *tweetSheet = [SLComposeViewController
                                                       composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:[NSString stringWithFormat:@"Check out %@ on G-Bay!", [view.stackFormView firstItemWithIdentifier:@"ItemName"].value]];
                if (photoArray.count == 0) {
                    [tweetSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://irs2.4sqi.net/img/general/500x500/2514_BvEN_Q6lG50xZQ9TIG0XY8eYXzF3USSMdtTmxHCmqnE.jpg"]]]];
                } else {
                    [tweetSheet addImage:photoArray[0]];
                }
                [self presentViewController:tweetSheet animated:YES completion:nil];
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
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Section Valid!" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
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
                                         
                                         FIRDataSnapshot *objectSnapshot = _objects[0];
                                         NSMutableDictionary *object = objectSnapshot.value;
                                         NSString *objectId = [NSString stringWithFormat:@"%lu", (unsigned long)object.count];
                                         if (metadataPath == nil) {
                                             [self addObject:@{@"userId": [FIRAuth auth].currentUser.uid, @"title": [view.stackFormView firstItemWithIdentifier:@"ItemName"].value, @"description": [view.stackFormView firstItemWithIdentifier:@"Description"].value, @"condition": [view.stackFormView firstItemWithIdentifier:@"Condition"].value, @"price": [view.stackFormView firstItemWithIdentifier:@"Price"].value, @"category": self.categoryString, @"latitude": [NSString stringWithFormat:@"%f", loc.coordinate.latitude], @"longitude": [NSString stringWithFormat:@"%f", loc.coordinate.longitude], @"objectId": objectId, @"paymentMethod": [view.stackFormView firstItemWithIdentifier:@"PaymentMethod"].value, @"handlingTime": [view.stackFormView firstItemWithIdentifier:@"HandlingTime"].value, @"returns": [view.stackFormView firstItemWithIdentifier:@"Returns"].value, @"deliveryType": [view.stackFormView firstItemWithIdentifier:@"DeliveryType"].value, @"shippingCosts": [view.stackFormView firstItemWithIdentifier:@"ShippingCosts"].value, @"shippingService": [view.stackFormView firstItemWithIdentifier:@"ShippingService"].value} withObjectId:objectId];
                                         } else {
                                             [self addObject:@{@"userId": [FIRAuth auth].currentUser.uid, @"title": [view.stackFormView firstItemWithIdentifier:@"ItemName"].value, @"description": [view.stackFormView firstItemWithIdentifier:@"Description"].value, @"condition": [view.stackFormView firstItemWithIdentifier:@"Condition"].value, @"price": [view.stackFormView firstItemWithIdentifier:@"Price"].value, @"category": self.categoryString, @"latitude": [NSString stringWithFormat:@"%f", loc.coordinate.latitude], @"longitude": [NSString stringWithFormat:@"%f", loc.coordinate.longitude], @"objectId": objectId, @"imageUrl": metadataPath, @"paymentMethod": [view.stackFormView firstItemWithIdentifier:@"PaymentMethod"].value, @"handlingTime": [view.stackFormView firstItemWithIdentifier:@"HandlingTime"].value, @"returns": [view.stackFormView firstItemWithIdentifier:@"Returns"].value, @"deliveryType": [view.stackFormView firstItemWithIdentifier:@"DeliveryType"].value, @"shippingCosts": [view.stackFormView firstItemWithIdentifier:@"ShippingCosts"].value, @"shippingService": [view.stackFormView firstItemWithIdentifier:@"ShippingService"].value} withObjectId:objectId];
                                         }
                                     }
                                 }];
                    
                    
                    
                }
            };
            builder.validationBlock = ^BOOL(__kindof INSStackFormViewBaseElement *view, INSStackFormItem *item, NSString **errorMessage) {
                if (![view.stackFormView firstItemWithIdentifier:@"DeliveryType"].value) {
                    *errorMessage = @"Delivery Type can't be nil.";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"ShippingCosts"].value) {
                    *errorMessage = @"Shipping Costs can't be nil";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"ShippingService"].value) {
                    *errorMessage = @"Shipping Service can't be nil";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"PaymentMethod"].value) {
                    *errorMessage = @"Payment Method can't be nil.";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"HandlingTime"].value) {
                    *errorMessage = @"Handling Time can't be nil";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"Returns"].value) {
                    *errorMessage = @"Returns can't be nil";
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
                else if (![view.stackFormView firstItemWithIdentifier:@"ItemName"].value) {
                    *errorMessage = @"Item Name can't be nil.";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"Price"].value) {
                    *errorMessage = @"Price can't be nil";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"Condition"].value) {
                    *errorMessage = @"Condition can't be nil";
                    return NO;
                }
                else if (![view.stackFormView firstItemWithIdentifier:@"Description"].value) {
                    *errorMessage = @"Description can't be nil";
                    return NO;
                }
                else if (!self.categoryString) {
                    *errorMessage = @"Category can't be nil";
                    return NO;
                }
//                else if (!metadataPath) {
//                    *errorMessage = @"Photos can't be nil";
//                    return NO;
//                }
                
                return YES;
            };
        }];
        
        
    }]];
    
    return sections;
}

- (void)addObject:(NSDictionary *)data withObjectId:(NSString *)objectId {
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    [[ref childByAutoId] setValue:mdata];
}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    pictureData = UIImagePNGRepresentation(image);
    
    [[_storageRef child:[NSString stringWithFormat:@"%@/%lld/asset.JPG", [FIRAuth auth].currentUser.uid, (long long)([[NSDate date] timeIntervalSince1970] * 1000.0)]]
     putData:pictureData metadata:nil
     completion:^(FIRStorageMetadata *metadata, NSError *error) {
         if (error) {
             NSLog(@"Error uploading: %@", error);
             FIRStorage *storage = [FIRStorage storage];
             FIRStorageReference *storageRef = [storage referenceForURL:@"gs://g-bay-70b9c.appspot.com"];
             //[self addObject:@{@"image":[storageRef child:metadata.path].description} withObjectId:@"20"];
             //metadataPath = [NSString stringWithFormat:@"%@,%@", metadataPath, [storageRef child:metadata.path].description];
             return;
         }
         FIRStorage *storage = [FIRStorage storage];
         FIRStorageReference *storageRef = [storage referenceForURL:@"gs://g-bay-70b9c.appspot.com"];
         metadataPath = [NSString stringWithFormat:@"%@,%@", metadataPath, [storageRef child:metadata.path].description];
;     }
     ];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (photoArray.count == 0) {
        // Create new Item
        INSStackFormItem *item = [[INSStackFormItem alloc] init];
        item.itemClass = [INSStackFormViewBaseElement class];
        item.height = @240;
        item.identifier = @"photosView";
        item.configurationBlock = ^(INSStackFormViewBaseElement *view) {
            view.backgroundColor = [UIColor clearColor];
            UIImageView *theImage = [[UIImageView alloc] initWithImage:image];
            [view addSubview:theImage];
            theImage.frame = CGRectMake(13, 5, 110, 110);
            didAdd = true;
            photoLines = 1;
        };
        photoArray = @[image];
        [self.stackFormView insertItems:@[item] toSection:self.stackFormView.sections[0] atIndex:7];
    }else if(photoArray.count%3 == 0) {
        //[self.stackFormView deleteItems:@[[self.stackFormView firstItemWithIdentifier:@"photosView"]]];
        INSStackFormItem *item = [self.stackFormView firstItemWithIdentifier:@"photosView"];
        item.height = [NSNumber numberWithInteger:120*(photoLines +1)];
        item.configurationBlock = ^(INSStackFormViewBaseElement *view){
            if (!didAdd) {
                UIImageView *theImage = [[UIImageView alloc] initWithImage:image];
                [view addSubview:theImage];
                theImage.frame = CGRectMake(13, 125, 110, 110);
                photoArray = [photoArray arrayByAddingObject:image];
                didAdd = true;
                photoLines += 1;
            }
        };
        [self.stackFormView refreshItems:@[item]];
    } else {
        //[self.stackFormView deleteItems:@[[self.stackFormView firstItemWithIdentifier:@"photosView"]]];
        INSStackFormItem *item = [self.stackFormView firstItemWithIdentifier:@"photosView"];
        item.configurationBlock = ^(INSStackFormViewBaseElement *view){
            if (!didAdd) {
                UIImageView *theImage = [[UIImageView alloc] initWithImage:image];
                [view addSubview:theImage];
                theImage.frame = CGRectMake(photoArray.count*120+13, 5, 110, 110);
                photoArray = [photoArray arrayByAddingObject:image];
                didAdd = true;
            }
        };
        [self.stackFormView refreshItems:@[item]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}





- (NewerItemViewController *)rootController
{
    if (!_rootController)
    {
        _rootController = [[NewerItemViewController alloc] init];
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
    if ([popoverIdentifier isEqualToString:@"Condition"]) {
        [self.stackFormView firstItemWithIdentifier:@"Condition"].value = conditionArray[indexPath.row];
        [self.stackFormView firstItemWithIdentifier:@"Condition"].title = [NSString stringWithFormat:@"Condition: %@",conditionArray[indexPath.row]];
        [self.stackFormView refreshItems:@[[self.stackFormView firstItemWithIdentifier:@"Condition"]]];
    } else if ([popoverIdentifier isEqualToString:@"State"]) {
        [self.stackFormView firstItemWithIdentifier:@"State"].value = stateArray[indexPath.row];
        [self.stackFormView firstItemWithIdentifier:@"State"].title = [NSString stringWithFormat:@"State: %@",stateArray[indexPath.row]];
        [self.stackFormView refreshItems:@[[self.stackFormView firstItemWithIdentifier:@"State"]]];
    } else if ([popoverIdentifier isEqualToString:@"PaymentMethod"]) {
        [self.stackFormView firstItemWithIdentifier:@"PaymentMethod"].value = paymentMethodArray[indexPath.row];
        [self.stackFormView firstItemWithIdentifier:@"PaymentMethod"].title = [NSString stringWithFormat:@"Payment Method: %@",paymentMethodArray[indexPath.row]];
        [self.stackFormView refreshItems:@[[self.stackFormView firstItemWithIdentifier:@"PaymentMethod"]]];
    } else if ([popoverIdentifier isEqualToString:@"HandlingTime"]) {
        [self.stackFormView firstItemWithIdentifier:@"HandlingTime"].value = handlingTimeArray[indexPath.row];
        [self.stackFormView firstItemWithIdentifier:@"HandlingTime"].title = [NSString stringWithFormat:@"Handling Time: %@",handlingTimeArray[indexPath.row]];
        [self.stackFormView refreshItems:@[[self.stackFormView firstItemWithIdentifier:@"HandlingTime"]]];
    } else if ([popoverIdentifier isEqualToString:@"Returns"]) {
        [self.stackFormView firstItemWithIdentifier:@"Returns"].value = returnsArray[indexPath.row];
        [self.stackFormView firstItemWithIdentifier:@"Returns"].title = [NSString stringWithFormat:@"Returns: %@", returnsArray[indexPath.row]];
        [self.stackFormView refreshItems:@[[self.stackFormView firstItemWithIdentifier:@"Returns"]]];
    } else if ([popoverIdentifier isEqualToString:@"DeliveryType"]) {
        [self.stackFormView firstItemWithIdentifier:@"DeliveryType"].value = deliveryTypeArray[indexPath.row];
        [self.stackFormView firstItemWithIdentifier:@"DeliveryType"].title = [NSString stringWithFormat:@"Type of Delivery: %@", deliveryTypeArray[indexPath.row]];
        [self.stackFormView refreshItems:@[[self.stackFormView firstItemWithIdentifier:@"DeliveryType"]]];
    } else if ([popoverIdentifier isEqualToString:@"ShippingService"]) {
        [self.stackFormView firstItemWithIdentifier:@"ShippingService"].value = shippingServiceArray[indexPath.row];
        [self.stackFormView firstItemWithIdentifier:@"ShippingService"].title = [NSString stringWithFormat:@"Shipping Service: %@", shippingServiceArray[indexPath.row]];
        [self.stackFormView refreshItems:@[[self.stackFormView firstItemWithIdentifier:@"ShippingService"]]];
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


-(void)stringFromSubview:(id)sender {
    self.categoryString = sender;
}






@end
