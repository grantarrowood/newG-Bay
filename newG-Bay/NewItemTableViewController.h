//
//  NewItemTableViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/4/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionPopoverViewController.h"
#import "AHTagTableViewCell.h"
#import "TagGroups.h"
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>
#import <Photos/Photos.h>


@interface NewItemTableViewController : UITableViewController <UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, popoverDelegate, CLLocationManagerDelegate>
{
    NSString *metadataPath;
    //    NSURL *imageFile;
    //    NSString *filePath;
    NSURL *referenceUrl;
}


@property (weak, nonatomic) IBOutlet UITableViewCell *categoryCell;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UITableView *theItemTableView;
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *addPhotosButton;
- (IBAction)addPhotosAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *streetTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitAction:(id)sender;
- (IBAction)changeCondition:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *conditionTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *imageCell;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoImageView;

@end
