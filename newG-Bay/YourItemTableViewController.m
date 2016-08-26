//
//  YourItemTableViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 8/23/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "YourItemTableViewController.h"
#import "DetailsViewController.h"

@interface YourItemTableViewController ()
{
    FIRDatabaseHandle _refHandle;
}

@end

@implementation YourItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _objects = [[NSMutableArray alloc] init];
    [_clientTable registerClass:UITableViewCell.self forCellReuseIdentifier:@"tableViewCell"];
    [self configureDatabase];
}

- (void)configureDatabase {
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    // Listen for new messages in the Firebase database
    _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary<NSString *, NSString *> *object = snapshot.value;
        NSString *isUserId = object[@"userId"];
        NSString *realUserId = [FIRAuth auth].currentUser.uid;
        if ([isUserId isEqualToString:realUserId]) {
            [_objects addObject:snapshot];
            [_clientTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue cell
    UITableViewCell *cell = [_clientTable dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    // Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *objectSnapshot = _objects[indexPath.row];
    NSDictionary<NSString *, NSString *> *object = objectSnapshot.value;
    NSString *name = object[@"title"];
    NSString *price = object[@"price"];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", price];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailsSegue" sender:self];
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FIRDataSnapshot *objectSnapshot = _objects[indexPath.row];
        NSDictionary<NSString *, NSString *> *object = objectSnapshot.value;
        DetailsViewController *destViewController = segue.destinationViewController;
        destViewController.title = object[@"title"];
        destViewController.dataDescription = object[@"description"];
        destViewController.condition = object[@"condition"];
        destViewController.price = object[@"price"];
        destViewController.category = object[@"category"];
        double lat = object[@"latitude"].doubleValue;
        double lon = object[@"longitude"].doubleValue;
        CLLocationCoordinate2D pointCoordinates;
        pointCoordinates.latitude = lat;
        pointCoordinates.longitude = lon;
        destViewController.locationLat = pointCoordinates.latitude;
        destViewController.locationLon = pointCoordinates.longitude;

        
    }
}

@end
