//
//  NewItemViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 8/22/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <Photos/Photos.h>

@interface NewItemViewController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate>
{
    NSString *metadataPath;
//    NSURL *imageFile;
//    NSString *filePath;
    NSURL *referenceUrl;
}

@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemConditionTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemCategoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemStreetTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemCityTextField;
- (IBAction)addPhotosAction:(id)sender;
- (IBAction)submitItemAction:(id)sender;

@end
