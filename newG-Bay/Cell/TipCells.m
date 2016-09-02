//
//  TipCell.m
//  TGFoursquareLocationDetail-Demo
//
//  Created by Thibault Guégan on 05/01/2014.
//  Copyright (c) 2014 Thibault Guégan. All rights reserved.
//

#import "TipCells.h"

@implementation TipCells

+ (TipCells*) tipCells
{
    TipCells *cell = [[[NSBundle mainBundle] loadNibNamed:@"TipCells" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
