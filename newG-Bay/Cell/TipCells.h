//
//  TipCell.h
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 05/01/2014.
//  Copyright (c) 2014 Thibault Guégan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipCells : UITableViewCell

+ (TipCells*) tipCells;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@end
