//
//  MessagingParticipantTableViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/22/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "ATLParticipantTableViewController.h"
#import <UIKit/UIKit.h>
@import Firebase;

@interface MessagingParticipantTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;
@end
