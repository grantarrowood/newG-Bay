//
//  BoughtItemsTableViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/21/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "BoughtItemsTableViewController.h"
#import "DetailsViewController.h"
#import "AllItemsTableViewCell.h"

@interface BoughtItemsTableViewController ()
{
    FIRDatabaseHandle _refHandle;
    NSArray *itemImage;
    BOOL firstItem;
}

@end

@implementation BoughtItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController setNavigationBarHidden:YES];
    _objects = [[NSMutableArray alloc] init];
    //[_clientTable registerClass:UITableViewCell.self forCellReuseIdentifier:@"tableViewCell"];
    [self configureDatabase];
    itemImage = [[NSArray alloc] init];
}
- (void)configureDatabase {
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    // Listen for new messages in the Firebase database
    _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary<NSString *, NSString *> *object = snapshot.value;
        NSString *isBoughtId = object[@"boughtId"];
        NSString *realUserId = [FIRAuth auth].currentUser.uid;
        if ([isBoughtId isEqualToString:realUserId]) {
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
    //UITableViewCell *cell = [_clientTable dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    AllItemsTableViewCell *cell = [_clientTable dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    // Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *objectSnapshot = _objects[indexPath.row];
    NSDictionary<NSString *, NSString *> *object = objectSnapshot.value;
    NSString *name = object[@"title"];
    NSString *price = object[@"price"];
    NSString *shippingCost = object[@"shippingCosts"];
    FIRStorage *storage = [FIRStorage storage];
    // Create a storage reference from our storage service
    NSArray *items = [object[@"imageUrl"] componentsSeparatedByString:@","];
    firstItem = true;
    for (int i = 0; i <= items.count-1; i++) {
        FIRStorageReference *storageRef = [storage referenceForURL:items[i]];
        
        [storageRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
            if (error != nil) {
                // Uh-oh, an error occurred!
                NSLog(@"Error Downloading: %@", error);
            } else {
                if (firstItem) {
                    cell.itemImage.image = [UIImage imageWithData:data];
                    firstItem = false;
                }
                itemImage = [itemImage arrayByAddingObject:[UIImage imageWithData:data]];
            }
        }];
    }
    
    
    cell.itemNameLabel.text = name;
    cell.itemPriceLabel.text = [NSString stringWithFormat:@"$%@", price];
    cell.itemShippingLabel.text = [NSString stringWithFormat:@"$%@ Shipping", shippingCost];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FIRDataSnapshot *objectSnapshot = _objects[indexPath.row];
    NSDictionary<NSString *, NSString *> *object = objectSnapshot.value;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *destViewController = (DetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    destViewController.itemImage = itemImage;
    destViewController.titled = object[@"title"];
    destViewController.dataDescription = object[@"description"];
    destViewController.condition = object[@"condition"];
    destViewController.price = object[@"price"];
    destViewController.category = object[@"category"];
    destViewController.paymentMethod = object[@"paymentMethod"];
    destViewController.handlingTime = object[@"handlingTime"];
    destViewController.returns = object[@"returns"];
    destViewController.deliveryType = object[@"deliveryType"];
    destViewController.shippingCosts = object[@"shippingCosts"];
    destViewController.shippingService = object[@"shippingService"];
    double lat = object[@"latitude"].doubleValue;
    double lon = object[@"longitude"].doubleValue;
    CLLocationCoordinate2D pointCoordinates;
    pointCoordinates.latitude = lat;
    pointCoordinates.longitude = lon;
    destViewController.locationLat = pointCoordinates.latitude;
    destViewController.locationLon = pointCoordinates.longitude;
    destViewController.ishidden = true;
    [[NSUserDefaults standardUserDefaults] setObject:@"YourItemsViewController"
                                              forKey:@"last_view"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:destViewController
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
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
        
        
    }
}
@end
