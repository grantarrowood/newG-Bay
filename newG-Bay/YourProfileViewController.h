//
//  YourProfileViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/19/16.
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
#import "JVMenuPopover.h"
#import <QuartzCore/QuartzCore.h>
#import "SlideNavigationController.h"
#import "AppDelegate.h"


@interface YourProfileViewController : UIViewController <UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, INSStackViewFormViewDateSource, CLLocationManagerDelegate, JVMenuPopoverDelegate>
{
    NSString *metadataPath;
    //    NSURL *imageFile;
    //    NSString *filePath;
    NSURL *referenceUrl;
}
@property (nonatomic, strong) YourProfileViewController *rootController;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

/** Holds the container view with the imageView and label in it. */
@property (nonatomic, strong, readwrite) UIView *containerView;

/** Holds the centred image view within the view controllers. */
@property (nonatomic, strong, readwrite) UIImageView *imageView;

/** Holds the menu image for the menu button. */
@property (nonatomic, strong, readwrite) UIImage *menuImg;

/** Holds the image to be used by the imageView. */
@property (nonatomic, strong, readwrite) UIImage *image;

/** Holds the menu title label. */
@property (nonatomic, strong, readwrite) UILabel *label;


@property (nonatomic, strong) JVMenuPopoverView *menuPopover;

@property (nonatomic, strong) JVMenuItems *menuItems;

@property (nonatomic, strong) CAGradientLayer *gradient;


@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic) NSString *categoryString;

@property (weak, nonatomic) IBOutlet INSStackFormView *stackFormView;
@end
