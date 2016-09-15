//
//  TipCell.m
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 05/01/2014.
//  Copyright (c) 2014 Thibault Guégan. All rights reserved.
//

#import "MediaCell.h"
#import <Social/Social.h>

@implementation MediaCell

+ (MediaCell*) mediaCell
{
    MediaCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MediaCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)facebookAction:(id)sender {
    
}

- (IBAction)instagramAction:(id)sender {
}

- (IBAction)twitterAction:(id)sender {
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end
