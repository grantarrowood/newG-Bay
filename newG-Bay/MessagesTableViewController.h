//
//  MessagesTableViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/23/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface MessagesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects2;

@end
