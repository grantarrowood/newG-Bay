//
//  NewItemTableViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/4/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "NewItemTableViewController.h"
#import "ConditionPopoverViewController.h"

@interface NewItemTableViewController ()

@end

@implementation NewItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.conditionTextField.text = _myString;
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
    
}
- (IBAction)submitAction:(id)sender {
    
}

- (IBAction)changeCondition:(id)sender {
    
//    // grab the view controller we want to show
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ConditionPopover"];
//    controller.preferredContentSize = CGSizeMake(275, 225);
//    // present the controller
//    // on iPad, this will be a Popover
//    // on iPhone, this will be an action sheet
//    controller.modalPresentationStyle = UIModalPresentationPopover;
//    [self presentViewController:controller animated:YES completion:nil];
//    
//    // configure the Popover presentation controller
//    UIPopoverPresentationController *popController = [controller popoverPresentationController];
//    popController.permittedArrowDirections = UIPopoverArrowDirectionDown;
//    popController.delegate = self;
//    
//    // in case we don't have a bar button as reference
//    popController.sourceRect = CGRectMake(50, 0, 275, 225);
    
    
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
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//    ConditionPopoverViewController *controller =  popoverController.contentViewController;
//    self.conditionTextField.text = controller.conditionString;
//    //Do something with data
//}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // called when a Popover is dismissed
    self.conditionTextField.text = _myString;
    NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
    
    // called when the Popover changes positon
}


@end
