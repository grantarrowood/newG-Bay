//
//  ARCameraViewController.m
//  G-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "ViewController.h"
@import FirebaseAuth;
#import "SlideNavigationController.h"

@interface ViewController ()
{
    CLLocationManager *locationManager;
    CLLocation *currentLocationNow;
    FIRDatabaseHandle _refHandle;
    NSString *email;
    NSString *username2;
    NSString *firstName;
    NSString *lastName;
    NSString *street;
    NSString *city;
    NSString *state;
    int gbayBalance;
    int tokenFound;
    int tokensAvalible;
    int feedbackNegative;
    int feedbackPositive;
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
    
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        NSLog(@"PASSED");
        // Sign-out succeeded
    }
    _objects = [[NSMutableArray alloc] init];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.loginToast appear];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

}


#pragma mark - nice colours.
- (UIColor *)eggshellGreen
{
    return [UIColor colorWithRed:114.0f/255.0f green:209.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

- (UIColor *)ectoplasmGreen
{
    //Mmmmmm, tastes like spooks.
    return [UIColor colorWithRed:114.0f/255.0f green:209.0f/255.0f blue:192.0f/255.0f alpha:0.75f];
}

- (UIColor *)candyCaneRed
{
    return [UIColor colorWithRed:211.0f/255.0f green:59.0f/255.0f blue:66.0f/255.0f alpha:1.0f];
}

- (UIColor *)jarringBlue
{
    return [UIColor colorWithRed:0.0f/255.0f green:176.0f/255.0f blue:193.0f/255.0f alpha:0.75f];
}


- (SWBufferedToast *)loginToast
{
    if (!_loginToast) {
        _loginToast = [[SWBufferedToast alloc] initLoginToastWithTitle:@"Login"
                                                         usernameTitle:@"Email"
                                                         passwordTitle:@"Password"
                                                             doneTitle:@"Sign In"
                                                  differentActionTitle:@"Create Account"
                                                      thirdActionTitle:@"Continue as Guest"
                                                      backgroundColour:self.ectoplasmGreen
                                                            toastColor:self.candyCaneRed
                                                   animationImageNames:nil andDelegate:self
                                                                onView:self.view];
    }
    
    return _loginToast;
}

- (SWBufferedToast *)registerToast
{
    if (!_registerToast) {
        _registerToast = [[SWBufferedToast alloc] initRegisterToastWithTitle:@"Create Account"
                                                         usernameTitle:@"Your Email"
                                                         passwordTitle:@"Your Password"
                                                        firstNameTitle:@"Your First Name"
                                                             doneTitle:@"Create Account"
                                                  differentActionTitle:@"Back"
                                                      backgroundColour:self.ectoplasmGreen
                                                            toastColor:self.candyCaneRed
                                                   animationImageNames:nil andDelegate:self
                                                                onView:self.view];
    }
    
    return _registerToast;
}

- (SWBufferedToast *)plainToast
{
    if (!_plainToast) {
        //Create a plain toast type. This toast is dismissable by swiping up and has an action button.
        //Implement the SWBufferedToastDelegate protocol to be notified of when the user taps the action button.
        _plainToast = [[SWBufferedToast alloc] initPlainToastWithTitle:@"Wrong"
                                                              subtitle:@"Wrong Password!"
                                                      actionButtonText:@"OK!"
                                                       backgroundColor:self.ectoplasmGreen
                                                            toastColor:self.eggshellGreen
                                                   animationImageNames:nil
                                                           andDelegate:self
                                                                onView:self.view];
    }
    
    return _plainToast;
}


- (void)didTapActionButtonWithToast:(SWBufferedToast *)toast
{
    if (toast == self.plainToast) {
        [self.plainToast dismiss];
        [self.loginToast appear];
        self.isRegistering = false;
        self.isError = false;
    }
}

-(void)didBeginRegistration:(SWBufferedToast*)toast
{
    if (toast == self.loginToast) {
        [self.loginToast dismiss];
        self.isRegistering = true;
        self.isError = false;
    }
}

-(void)didBeginBack:(SWBufferedToast*)toast
{
    if (toast == self.registerToast) {
        [self.registerToast dismiss];
        self.isRegistering = false;
        self.isError = false;
    }
}
-(void)didBeginContinue:(SWBufferedToast *)toast
{
    [self.loginToast dismiss];
    NSLog(@"%@", [FIRAuth auth].currentUser.uid);
    [self performSegueWithIdentifier:@"toMainView" sender:self];
}

- (void)didAttemptLoginWithUsername:(NSString *)username
                        andPassword:(NSString *)password
                          withToast:(SWBufferedToast *)toast
{
    if (toast == self.loginToast) {
        //Returns the values the user entered for their username and password. You should probably attempt a login at this point.
        [self.loginToast beginLoading];
        //Once you have authed with your api you can dismiss the toast by calling
        [[FIRAuth auth] signInWithEmail:username
                               password:password
                             completion:^(FIRUser *user, NSError *error) {
                                 if (error) {
                                     self.isError = true;
                                     [self.loginToast dismiss];
                                 } else {
                                     FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/users"];
                                     _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
                                         NSString *key = [NSString stringWithFormat:@"%@",user.uid];
                                         NSLog(@"%@", key);
                                         NSLog(@"%@", snapshot.key);
                                         if ([snapshot.key isEqualToString: key]) {
                                             [_objects addObject:snapshot];
                                             NSDictionary<NSString *, NSString *> *object = snapshot.value;
                                             feedbackPositive = object[@"feedbackPositive"].intValue;
                                             feedbackNegative = object[@"feedbackNegative"].intValue;
                                             tokenFound = object[@"tokenFound"].intValue;
                                             tokensAvalible = object[@"tokenAvaliable"].intValue;
                                             gbayBalance = object[@"Gbalance"].intValue;
                                             firstName = object[@"firstName"];
                                             username2 = object[@"userName"];
                                             lastName = object[@"lastName"];
                                             float locationLat = object[@"locationLat"].floatValue;
                                             float locationLon = object[@"locationLon"].floatValue;
                                             CLLocation *location = [[CLLocation alloc]
                                                                     initWithLatitude:locationLat
                                                                     longitude:locationLon];
                                             
                                             CLGeocoder* geocoder = [[CLGeocoder alloc] init];
                                             [geocoder
                                              reverseGeocodeLocation:location
                                              completionHandler:^(NSArray *placemarks, NSError *error) {
                                                  
                                                  CLPlacemark *placemark = [placemarks lastObject];
                                                  NSString *address = [NSString stringWithFormat:@"%@ %@ %@, %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea];
                                                  street = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
                                                  city = placemark.locality;
                                                  state = placemark.administrativeArea;
                                                  
                                                  if(!lastName || !street || !city || !state || !username2) {
                                                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                      // when your application opens:
                                                      //                NSString * viewIdentifierString = [[NSUserDefaults standardUserDefaults]
                                                      //                                                   stringForKey:@"last_view"];
                                                      UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
                                                      
                                                      [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                                                                               withSlideOutAnimation:NO
                                                                                                                       andCompletion:nil];
                                                  } else {
                                                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                      int i = [defaults integerForKey:@"tillNextToken"];
                                                      if (i == 2) {
                                                          i = 0;
                                                          [self addObject:@{@"userId": user.uid, @"latitude": [NSString stringWithFormat:@"%f", currentLocationNow.coordinate.latitude-.000062], @"longitude": [NSString stringWithFormat:@"%f", currentLocationNow.coordinate.longitude-.00007]}];
                                                          /// CHANGE THE TOKEN COUNT AND TOKENS AVAILIABLE WITH USERS!!!!
                                                          
                                                      } else {
                                                          i += 1;
                                                      }
                                                      
                                                      [defaults setInteger:i forKey:@"tillNextToken"];
                                                      
                                                      [defaults synchronize];
                                                      [self.loginToast dismiss];
                                                      NSLog(@"%@", user.uid);
                                                      [self performSegueWithIdentifier:@"toMainView" sender:self];
                                                  }

                                                  
                                              }];
                                         } else {
                                             
                                         }
                                         
                                     }];

                                 }
                                 
                }];
    }
}

- (void)didAttemptCreateWithUsername:(NSString *)username Password:(NSString *)password andFirstName:(NSString *)firstName withToast:(SWBufferedToast *)toast
{
    
    
    [[FIRAuth auth] createUserWithEmail:username password:password completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
        if (error) {
            [self.loginToast dismiss];
            [self.plainToast appear];
        } else {
            [self addObjectUsers:@{@"Gbalance": @"0", @"firstName": firstName} withUserId:user];
            [self.loginToast dismiss];
            NSLog(@"PASSED");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            // when your application opens:
            //                NSString * viewIdentifierString = [[NSUserDefaults standardUserDefaults]
            //                                                   stringForKey:@"last_view"];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                                     withSlideOutAnimation:NO
                                                                             andCompletion:nil];
        }
    }];
    
    
    
    
}


- (void)didDismissToastView:(SWBufferedToast *)toast
{
    //Called when a toast has been dismissed.
    if ((toast == self.loginToast) && (_isRegistering)) {
        [self.registerToast appear];
    } else if (toast == self.registerToast)
    {
        [self.loginToast appear];
    } else if ((toast == self.loginToast) && (_isError))
    {
        [self.plainToast appear];

    }
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
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        currentLocationNow = currentLocation;
    }
}

- (void)addObject:(NSDictionary *)data {
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/tokens"];
    [[ref childByAutoId] setValue:mdata];
}

- (void)addObjectUsers:(NSDictionary *)data withUserId:(FIRUser *)user {
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/users"];
    [[ref child:user.uid] setValue:mdata];
}


@end
