//
//  ARCameraViewController.h
//  G-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRARManager.h"
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>

@interface ARCameraViewController : UIViewController <PRARManagerDelegate, CLLocationManagerDelegate>

@end
