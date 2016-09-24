//
//  ConversationTableViewCell.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/23/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
