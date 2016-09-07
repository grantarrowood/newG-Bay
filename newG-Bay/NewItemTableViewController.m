//
//  NewItemTableViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/4/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "NewItemTableViewController.h"



@interface NewItemTableViewController (){
    NSArray<NSArray<AHTag *> *> *_dataSource;
    NSURL *imageFile;
    NSString *filePath;
    NSData* pictureData;
}


@end

@implementation NewItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [TagGroups dataSource:[NSMutableString stringWithString:@"12"]];
    // Uncomment the following line to preserve selection between presentations. 1112131415161718192021
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib = [UINib nibWithNibName:@"AHTagTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    UITableViewCell *cell = [self.theItemTableView dequeueReusableCellWithIdentifier:@"cell"];
    [self configureCell:cell];
    self.categoryCell = cell;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
    _objects = [[NSMutableArray alloc] init];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [_objects addObject:snapshot];
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    self.storageRef = [[FIRStorage storage] referenceForURL:@"gs://g-bay-70b9c.appspot.com"];

}


- (void)configureCell:(id)object{
    if (![object isKindOfClass:[AHTagTableViewCell class]]) {
        return;
    }
    AHTagTableViewCell *cell = (AHTagTableViewCell *)object;
    cell.label.tags = _dataSource[0];
    cell.label.userInteractionEnabled = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 2;
    } else if (section == 3) {
        return 1;
    } else {
        return 0;
    }
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addPhotosAction:(id)sender {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];

    
}
- (IBAction)submitAction:(id)sender {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.streetTextField.text
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     for (CLPlacemark* aPlacemark in placemarks)
                     {
                         // Process the placemark.
                         CLLocation *loc = aPlacemark.location;
                         NSLog(@"View Controller get Location Logitute : %f",loc.coordinate.latitude);
                         NSLog(@"View Controller get Location Latitute : %f",loc.coordinate.longitude);
                         // Get objects then
                         
                         FIRDataSnapshot *objectSnapshot = _objects[0];
                         NSMutableDictionary *object = objectSnapshot.value;
                         NSString *objectId = [NSString stringWithFormat:@"%lu", (unsigned long)object.count];
                         if (metadataPath == nil) {
                             [self addObject:@{@"userId": [FIRAuth auth].currentUser.uid, @"title": self.itemNameTextField.text, @"description": self.descriptionTextView.text, @"condition": self.conditionTextField.text, @"price": self.priceTextField.text, @"category": @"12345", @"latitude": [NSString stringWithFormat:@"%f", loc.coordinate.latitude], @"longitude": [NSString stringWithFormat:@"%f", loc.coordinate.longitude], @"objectId": objectId} withObjectId:objectId];
                         } else {
                             [self addObject:@{@"userId": [FIRAuth auth].currentUser.uid, @"title": self.itemNameTextField.text, @"description": self.descriptionTextView.text, @"condition": self.conditionTextField.text, @"price": self.priceTextField.text, @"category": @"12345", @"latitude": [NSString stringWithFormat:@"%f", loc.coordinate.latitude], @"longitude": [NSString stringWithFormat:@"%f", loc.coordinate.longitude], @"objectId": objectId, @"imageUrl": metadataPath} withObjectId:objectId];
                         }
                     }
    }];

    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    pictureData = UIImagePNGRepresentation(image);
    
    [[_storageRef child:[NSString stringWithFormat:@"%@/%lld/asset.JPG", [FIRAuth auth].currentUser.uid, (long long)([[NSDate date] timeIntervalSince1970] * 1000.0)]]
     putData:pictureData metadata:nil
     completion:^(FIRStorageMetadata *metadata, NSError *error) {
         if (error) {
             NSLog(@"Error uploading: %@", error);
             FIRStorage *storage = [FIRStorage storage];
             FIRStorageReference *storageRef = [storage referenceForURL:@"gs://g-bay-70b9c.appspot.com"];
             //[self addObject:@{@"image":[storageRef child:metadata.path].description} withObjectId:@"20"];
             metadataPath = [storageRef child:metadata.path].description;
             return;
         }
         FIRStorage *storage = [FIRStorage storage];
         FIRStorageReference *storageRef = [storage referenceForURL:@"gs://g-bay-70b9c.appspot.com"];
         metadataPath = [storageRef child:metadata.path].description;
     }
     ];
//    UIImageView *newImageView = [[UIImageView alloc] initWithImage:image];
//    [newImageView setFrame:CGRectMake(13, 0, 90, 90)];
    //[self.imageCell addSubview:newImageView];
//    UITableViewCell *cell = [self.theItemTableView dequeueReusableCellWithIdentifier:@"imageCell"];
//    [cell addSubview:self.addPhotosButton];
    self.addPhotoImageView.image = image;
    self.addPhotoImageView.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"%f", _addPhotosButton.frame.origin.x);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)changeCondition:(id)sender {
    
}

-(void) updateInfo:(UIPopoverPresentationController *)popoverPresentationViewController
{
    NSLog(@"Hello");
    ConditionPopoverViewController *vc = popoverPresentationViewController.presentedViewController;
    self.conditionTextField.text = vc.conditionString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Assuming you've hooked this all up in a Storyboard with a popover presentation style
    if ([segue.identifier isEqualToString:@"showPopover"]) {
        //UINavigationController *destNav = segue.destinationViewController;
        ConditionPopoverViewController *vc = segue.destinationViewController;
        vc.preferredContentSize = CGSizeMake(275, 225);
        //vc.modalPresentationStyle = UIModalPresentationPopover;
        vc.popoverDelegate = self;
        //[self presentViewController:vc animated:YES completion:nil];
        // This is the important part
        UIPopoverPresentationController *popPC = vc.popoverPresentationController;
        popPC.delegate = self;
        popPC.sourceRect = CGRectMake(50, 0, 275, 225);
    }
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)addObject:(NSDictionary *)data withObjectId:(NSString *)objectId {
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    [[ref childByAutoId] setValue:mdata];
}


@end
