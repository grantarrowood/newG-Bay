//
//  AddressLocationCell.h
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 17/12/2013.
//  Copyright (c) 2013 Thibault Guégan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AddressLocationCell : UITableViewCell

+ (AddressLocationCell*) addressLocationDetailCell;
@property (weak, nonatomic) IBOutlet UILabel *streetAddress;
@property (weak, nonatomic) IBOutlet UILabel *cityAddress;
@property (weak, nonatomic) IBOutlet UILabel *stateAddress;

@end