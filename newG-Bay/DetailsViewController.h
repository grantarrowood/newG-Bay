//
//  DetailsViewController.h
//  G-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailsViewController : UIViewController <CLLocationManagerDelegate>

@property(nonatomic) NSString* title;
@property(nonatomic) NSMutableString* dataDescription;
@property(nonatomic) NSString* condition;
@property(nonatomic) NSNumber* price;
@property(nonatomic) NSString* category;
@property(nonatomic) NSString* GBalanceText;
@property(nonatomic) int theid;
@property(nonatomic) double locationLat;
@property(nonatomic) double locationLon;
@property(nonatomic) bool ishidden;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *foundTokenView;
@property (weak, nonatomic) IBOutlet UILabel *totalGBalance;

@end
