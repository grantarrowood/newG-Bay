//
//  NewItemViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 8/22/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "NewItemViewController.h"


@interface NewItemViewController ()
{
    NSURL *imageFile;
    NSString *filePath;
    NSData* pictureData;
    
}

@end

@implementation NewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _objects = [[NSMutableArray alloc] init];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [_objects addObject:snapshot];
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    self.storageRef = [[FIRStorage storage] referenceForURL:@"gs://g-bay-70b9c.appspot.com"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [picker dismissViewControllerAnimated:YES completion:NULL];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)addPhotosAction:(id)sender {
    
    
    // Make imge Picker Controller Pop up.
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];

}

- (IBAction)submitItemAction:(id)sender {
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.itemStreetTextField.text
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
                             [self addObject:@{@"userId": [FIRAuth auth].currentUser.uid, @"title": self.itemNameTextField.text, @"description": self.itemDescriptionTextField.text, @"condition": self.itemConditionTextField.text, @"price": self.itemPriceTextField.text, @"category": self.itemCategoryTextField.text, @"latitude": [NSString stringWithFormat:@"%f", loc.coordinate.latitude], @"longitude": [NSString stringWithFormat:@"%f", loc.coordinate.longitude], @"objectId": objectId} withObjectId:objectId];
                         } else {
                             [self addObject:@{@"userId": [FIRAuth auth].currentUser.uid, @"title": self.itemNameTextField.text, @"description": self.itemDescriptionTextField.text, @"condition": self.itemConditionTextField.text, @"price": self.itemPriceTextField.text, @"category": self.itemCategoryTextField.text, @"latitude": [NSString stringWithFormat:@"%f", loc.coordinate.latitude], @"longitude": [NSString stringWithFormat:@"%f", loc.coordinate.longitude], @"objectId": objectId, @"imageUrl": metadataPath} withObjectId:objectId];
                         }
                    }
                 }];
    
    
}

- (void)addObject:(NSDictionary *)data withObjectId:(NSString *)objectId {
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    [[ref childByAutoId] setValue:mdata];
}

@end
