//
//  BoughtItemsTableViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/21/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface BoughtItemsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) IBOutlet UITableView *clientTable;

@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;

@end
