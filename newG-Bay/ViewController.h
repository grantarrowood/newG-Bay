//
//  ViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "SWBufferedToast/SWBufferedToast.h"


@interface ViewController : UIViewController <CLLocationManagerDelegate, SWBufferedToastDelegate>
@property (nonatomic, strong) SWBufferedToast *plainToast;
@property (nonatomic, strong) SWBufferedToast *loginToast;
@property (nonatomic, strong) SWBufferedToast *registerToast;
@property (nonatomic) bool isRegistering;



@property (nonatomic, readonly) UIColor *eggshellGreen;
@property (nonatomic, readonly) UIColor *ectoplasmGreen;
@property (nonatomic, readonly) UIColor *candyCaneRed;
@property (nonatomic, readonly) UIColor *jarringBlue;


- (IBAction)loginAction:(id)sender;

@end



