//
//  MainViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 8/21/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "MainViewController.h"
#import "LeftMenuViewController.h"
@import FirebaseAuth;

@interface MainViewController ()
@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    
    // Do any additional setup after loading the view.
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

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}


- (IBAction)logOutAction:(id)sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"PASSED");
        // Sign-out succeeded
    }
}
@end
