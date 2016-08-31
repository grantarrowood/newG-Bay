//
//  MainViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 8/21/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"



@interface MainViewController : UIViewController <SlideNavigationControllerDelegate>


- (IBAction)logOutAction:(id)sender;

@end
