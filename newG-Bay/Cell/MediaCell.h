//
//  TipCell.h
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 05/01/2014.
//  Copyright (c) 2014 Thibault Guégan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCell : UITableViewCell

+ (MediaCell*) mediaCell;

- (IBAction)facebookAction:(id)sender;
- (IBAction)instagramAction:(id)sender;
- (IBAction)twitterAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *faceBookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@end
