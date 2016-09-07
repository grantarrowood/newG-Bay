//
//  ConditionPopoverViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/4/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "ConditionPopoverViewController.h"

@interface ConditionPopoverViewController (){

}
@end

@implementation ConditionPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pickerData = @[@"New", @"Like New", @"Verry Good", @"Good", @"Horrible"];
    self.conditionPickerView.delegate = self;
    self.conditionPickerView.dataSource = self;
    self.conditionString = self.pickerData[0];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    self.selectedRow = row;
    self.conditionString = self.pickerData[row];
    
    
}


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//
//}


- (IBAction)doneBarAction:(id)sender {
    [self.popoverDelegate updateInfo:self.popoverPresentationController];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
