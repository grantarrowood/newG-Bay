//
//  ConditionPopoverViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/4/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol popoverDelegate
-(void)updateInfo: (UIPopoverPresentationController *)popoverPresentationViewController;
@end


@interface ConditionPopoverViewController : UIViewController <UIPopoverControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic) NSArray *pickerData;
@property (nonatomic) NSInteger selectedRow;
@property (weak) id<popoverDelegate>  popoverDelegate;
@property (weak, nonatomic) NSString *conditionString;

@property (weak, nonatomic) IBOutlet UIPickerView *conditionPickerView;
- (IBAction)doneBarAction:(id)sender;
@end
