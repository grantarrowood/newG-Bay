//
//  YourItemTableViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 8/23/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface AllItemsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) IBOutlet UITableView *clientTable;

@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;

@end
