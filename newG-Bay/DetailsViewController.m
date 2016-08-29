//
//  DetailsViewController.m
//  G-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CLLocation *location = [[CLLocation alloc]
                            initWithLatitude:_locationLat
                            longitude:_locationLon];
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder
     reverseGeocodeLocation:location
     completionHandler:^(NSArray *placemarks, NSError *error) {
         
         CLPlacemark *placemark = [placemarks lastObject];
         NSString *address = [NSString stringWithFormat:@"%@ %@ %@, %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea];
         self.addressLabel.text = address;
     }];
    
    
    self.titleLabel.text = self.title;
    self.descriptionLabel.text = self.dataDescription;
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", self.price];
    self.conditionLabel.text = self.condition;
    self.categoryLabel.text = self.category;
    self.foundTokenView.hidden = self.ishidden;
    self.totalGBalance.text = self.GBalanceText;
    
    
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

@end
