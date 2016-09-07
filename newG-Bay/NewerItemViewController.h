//
//  NewerItemViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/5/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "INSStackFormView.h"
#import "INSStackFormViewLabelElement.h"
#import "INSStackFormViewTextFieldElement.h"
#import "INSStackFormViewTextViewElement.h"
#import "FTPopoverMenu.h"
#import "ANTagsView.h"
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>
#import <Photos/Photos.h>



@interface NewerItemViewController : UIViewController <UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, INSStackViewFormViewDateSource, CLLocationManagerDelegate>
{
    NSString *metadataPath;
    //    NSURL *imageFile;
    //    NSString *filePath;
    NSURL *referenceUrl;
}

@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic) NSString *categoryString;

@property (weak, nonatomic) IBOutlet INSStackFormView *stackFormView;

@end
