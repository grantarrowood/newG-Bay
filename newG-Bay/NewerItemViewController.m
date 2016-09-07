//
//  NewerItemViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/5/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "NewerItemViewController.h"
#import "ConditionPopoverViewController.h"

@interface NewerItemViewController () <subViewDelegate> {
    NSURL *imageFile;
    NSString *filePath;
    NSData* pictureData;
    
}

@end

@implementation NewerItemViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    _objects = [[NSMutableArray alloc] init];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [_objects addObject:snapshot];
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    self.storageRef = [[FIRStorage storage] referenceForURL:@"gs://g-bay-70b9c.appspot.com"];

    [self.stackFormView addSections:[self sectionsForStackFormView:self.stackFormView]];
    
    //[self.stackFormView insertItems:@[item] toSection:self.stackFormView.sections[0] atIndex:2];
    


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
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.identifier = @"Condition";
            builder.title = @"Condition";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Condition";
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
                view.textField.keyboardType = UIKeyboardTypeNumberPad;
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            builder.identifier = @"State";
            builder.title = @"State";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"State";
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
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            //Drop Down
            builder.title = @"Payment Method";
            builder.identifier = @"PaymentMethod";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Payment Method";
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            //Drop Down
            builder.identifier = @"HandlingTime";
            builder.title = @"Handling Time";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Handling Time";
            };
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            //Drop Down
            builder.identifier = @"Returns";
            builder.title = @"Returns";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Returns";
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
            builder.title = @"Shipping or Pickup";
            builder.height = @56;
            builder.userInteractionEnabled = NO;
            builder.actionBlock = nil;
        }];
        
        [sectionBuilder addItemWithBuilder:^(INSStackFormItem *builder) {
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            //Drop Down
            builder.title = @"Type of Delivery";
            builder.identifier = @"DeliveryType";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Type of Delivery";
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
            builder.itemClass = [INSStackFormViewTextFieldElement class];
            //Drop Down
            builder.identifier = @"Time";
            builder.title = @"Shipping Time";
            builder.subtitle = nil;
            builder.height = @50;
            builder.configurationBlock = ^(INSStackFormViewTextFieldElement *view) {
                view.textField.placeholder = @"Shipping Time";
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
                                             [self addObject:@{@"userId": [FIRAuth auth].currentUser.uid, @"title": [view.stackFormView firstItemWithIdentifier:@"ItemName"].value, @"description": [view.stackFormView firstItemWithIdentifier:@"Description"].value, @"condition": [view.stackFormView itemWithIdentifier:@"Condition" inSection:[view.stackFormView sectionWithIdentifier:@"ItemDetails"]].value, @"price": [view.stackFormView firstItemWithIdentifier:@"Price"].value, @"category": self.categoryString, @"latitude": [NSString stringWithFormat:@"%f", loc.coordinate.latitude], @"longitude": [NSString stringWithFormat:@"%f", loc.coordinate.longitude], @"objectId": objectId} withObjectId:objectId];
                                         } else {
                                             [self addObject:@{@"userId": [FIRAuth auth].currentUser.uid, @"title": [view.stackFormView firstItemWithIdentifier:@"ItemName"].value, @"description": [view.stackFormView firstItemWithIdentifier:@"Description"].value, @"condition": [view.stackFormView firstItemWithIdentifier:@"Condition"].value, @"price": [view.stackFormView firstItemWithIdentifier:@"Price"].value, @"category": self.categoryString, @"latitude": [NSString stringWithFormat:@"%f", loc.coordinate.latitude], @"longitude": [NSString stringWithFormat:@"%f", loc.coordinate.longitude], @"objectId": objectId, @"imageUrl": metadataPath} withObjectId:objectId];
                                         }
                                     }
                                 }];

                    
                    
                }
            };
            builder.validationBlock = ^BOOL(__kindof INSStackFormViewBaseElement *view, INSStackFormItem *item, NSString **errorMessage) {
//                if (![view.stackFormView firstItemWithIdentifier:@"DeliveryType"].value) {
//                    *errorMessage = @"Delivery Type can't be nil.";
//                    return NO;
//                }
                if (![view.stackFormView firstItemWithIdentifier:@"ShippingCosts"].value) {
                    *errorMessage = @"Shipping Costs can't be nil";
                    return NO;
                }
//                else if (![view.stackFormView firstItemWithIdentifier:@"Time"].value) {
//                    *errorMessage = @"Time can't be nil";
//                    return NO;
//                }
//                else if (![view.stackFormView firstItemWithIdentifier:@"PaymentMethod"].value) {
//                    *errorMessage = @"Payment Method can't be nil.";
//                    return NO;
//                }
//                else if (![view.stackFormView firstItemWithIdentifier:@"HandlingTime"].value) {
//                    *errorMessage = @"Handling Time can't be nil";
//                    return NO;
//                }
//                else if (![view.stackFormView firstItemWithIdentifier:@"Returns"].value) {
//                    *errorMessage = @"Returns can't be nil";
//                    return NO;
//                }
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
                //                else if (![view.stackFormView firstItemWithIdentifier:@"Condition"].value) {
                //                    *errorMessage = @"Condition can't be nil";
                //                    return NO;
                //                }
                else if (![view.stackFormView firstItemWithIdentifier:@"Description"].value) {
                    *errorMessage = @"Description can't be nil";
                    return NO;
                }
                //                else if (![view.stackFormView firstItemWithIdentifier:@"Category"].value) {
                //                    *errorMessage = @"Category can't be nil";
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


-(void)stringFromSubview:(id)sender {
    NSLog(@"Hello");
    self.categoryString = sender;
}


@end
