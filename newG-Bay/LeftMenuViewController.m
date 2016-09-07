//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
@import FirebaseAuth;

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.separatorColor = [UIColor lightGrayColor];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud"]];
    self.tableView.backgroundView = imageView;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView insertRowsAtIndexPaths:@[] withRowAnimation: UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([FIRAuth auth].currentUser.uid != nil) {
        return 8;
    } else {
        return 5;
    }
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    if ([FIRAuth auth].currentUser.uid != nil) {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Home";
                break;
                
            case 1:
                cell.textLabel.text = @"Open Camera";
                break;
                
            case 2:
                cell.textLabel.text = @"View All Items";
                break;
                
            case 3:
                cell.textLabel.text = @"View Map";
                break;
                
            case 4:
                cell.textLabel.text = @"View Your Items";
                break;
                
            case 5:
                cell.textLabel.text = @"Add Items";
                break;
            
            case 6:
                cell.textLabel.text = @"Profile";
                break;
                
            case 7:
                cell.textLabel.text = @"Sign Out";
                break;
        }

    } else {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Home";
                break;
                
            case 1:
                cell.textLabel.text = @"Open Camera";
                break;
                
            case 2:
                cell.textLabel.text = @"View All Items";
                break;
                
            case 3:
                cell.textLabel.text = @"View Map";
                break;
                
            case 4:
                cell.textLabel.text = @"Sign In";
                break;
        }

    }
    cell.textLabel.textColor = [UIColor whiteColor];
	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle: nil];
	
	UIViewController *vc ;
	if ([FIRAuth auth].currentUser.uid != nil) {
        switch (indexPath.row)
        {
            case 0:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainViewController"];
                break;
                
            case 1:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"OpenCameraViewController"];
                break;
                
            case 2:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AllItemsViewController"];
                break;
                
            case 3:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ItemMapViewController"];
                break;
                
            case 4:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"YourItemsViewController"];
                break;
                
            case 5:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"NewItem"];
                break;
            
            case 6:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
                break;
                
            case 7:
                [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
                NSError *error;
                [[FIRAuth auth] signOut:&error];
                if (!error) {
                    NSLog(@"PASSED");
                    // Sign-out succeeded
                }
                return;
                break;
        }
    } else {
        switch (indexPath.row)
        {
            case 0:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MainViewController"];
                break;
                
            case 1:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"OpenCameraViewController"];
                break;
                
            case 2:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AllItemsViewController"];
                break;
                
            case 3:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ItemMapViewController"];
                break;
                
            case 4:
                [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
                return;
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:nil];
}

@end
