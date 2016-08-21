//
//  DetailsViewController.h
//  G-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailsViewController : UIViewController

@property(nonatomic) NSString* title;
@property(nonatomic) int theid;
@property(nonatomic) double locationLat;
@property(nonatomic) double locationLon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;




@end
