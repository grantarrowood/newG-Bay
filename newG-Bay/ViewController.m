//
//  ARCameraViewController.m
//  G-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "ViewController.h"
@import FirebaseAuth;

@interface ViewController ()
{
    CLLocationManager *locationManager;
    CLLocation *currentLocationNow;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        currentLocationNow = currentLocation;
    }
}



- (IBAction)loginAction:(id)sender {

    [[FIRAuth auth] signInWithEmail:@"grant@arrowood.com"
                           password:@"abcd1234"
                         completion:^(FIRUser *user, NSError *error) {
                             
                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                             int i = [defaults integerForKey:@"tillNextToken"];
                             if (i == 2) {
                                 i = 0;
                                     [self addObject:@{@"userId": user.uid, @"latitude": [NSString stringWithFormat:@"%f", currentLocationNow.coordinate.latitude-.000062], @"longitude": [NSString stringWithFormat:@"%f", currentLocationNow.coordinate.longitude-.00007]}];

                             } else {
                                 i += 1;
                             }
                             
                             [defaults setInteger:i forKey:@"tillNextToken"];
                             
                             [defaults synchronize];
                            NSLog(@"PASSED");
                         }];


}
- (void)addObject:(NSDictionary *)data {
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/tokens"];
    [[ref childByAutoId] setValue:mdata];
}



@end
