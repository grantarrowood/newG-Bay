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
                                                      NSURL *appID = [NSURL URLWithString:@"layer:///apps/staging/e81bbe7a-8118-11e6-86b6-c7b7000000b4"];
                                                      self.layerClient = [LYRClient clientWithAppID:appID];
                                                      [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
                                                          if (!success) {
                                                              NSLog(@"Failed to connect to Layer: %@", error);
                                                          } else {
                                                              // For the purposes of this Quick Start project, let's authenticate as a user named 'Device'.  Alternatively, you can authenticate as a user named 'Simulator' if you're running on a Simulator.
                                                              NSString *userIDString = @"Simulator";
                                                              // Once connected, authenticate user.
                                                              // Check Authenticate step for authenticateLayerWithUserID source
                                                              [self authenticateLayerWithUserID:userIDString completion:^(BOOL success, NSError *error) {
                                                                  if (!success) {
                                                                      NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                                                                  }
                                                              }];
                                                          }
                                                      }];
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



- (void)authenticateLayerWithUserID:(NSString *)userID completion:(void (^)(BOOL success, NSError * error))completion
{
    // Check to see if the layerClient is already authenticated.
    if (self.layerClient.authenticatedUser) {
        // If the layerClient is authenticated with the requested userID, complete the authentication process.
        if ([self.layerClient.authenticatedUser.userID isEqualToString:userID]){
            NSLog(@"Layer Authenticated as User %@", self.layerClient.authenticatedUser.userID);
            if (completion) completion(YES, nil);
            return;
        } else {
            //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
            [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
                if (!error){
                    [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
                        if (completion){
                            completion(success, error);
                        }
                    }];
                } else {
                    if (completion){
                        completion(NO, error);
                    }
                }
            }];
        }
    } else {
        // If the layerClient isn't already authenticated, then authenticate.
        [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
            if (completion){
                completion(success, error);
            }
        }];
    }
}

- (void)authenticationTokenWithUserId:(NSString *)userID completion:(void (^)(BOOL success, NSError* error))completion{
    
    /*
     * 1. Request an authentication Nonce from Layer
     */
    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        /*
         * 2. Acquire identity Token from Layer Identity Service
         */
        [self requestIdentityTokenForUserID:userID appID:[self.layerClient.appID absoluteString] nonce:nonce completion:^(NSString *identityToken, NSError *error) {
            if (!identityToken) {
                if (completion) {
                    completion(NO, error);
                }
                return;
            }
            
            /*
             * 3. Submit identity token to Layer for validation
             */
            [self.layerClient authenticateWithIdentityToken:identityToken completion:^(LYRIdentity *authenticatedUser, NSError *error) {
                if (authenticatedUser) {
                    if (completion) {
                        completion(YES, nil);
                    }
                    NSLog(@"Layer Authenticated as User: %@", authenticatedUser.userID);
                } else {
                    completion(NO, error);
                }
            }];
        }];
    }];
}


- (void)requestIdentityTokenForUserID:(NSString *)userID appID:(NSString *)appID nonce:(NSString *)nonce completion:(void(^)(NSString *identityToken, NSError *error))completion
{
    NSParameterAssert(userID);
    NSParameterAssert(appID);
    NSParameterAssert(nonce);
    NSParameterAssert(completion);
    
    NSURL *identityTokenURL = [NSURL URLWithString:@"https://layer-identity-provider.herokuapp.com/identity_tokens"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *parameters = @{ @"app_id": appID, @"user_id": userID, @"nonce": nonce };
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // Deserialize the response
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![responseObject valueForKey:@"error"])
        {
            NSString *identityToken = responseObject[@"identity_token"];
            completion(identityToken, nil);
        }
        else
        {
            NSString *domain = @"layer-identity-provider.herokuapp.com";
            NSInteger code = [responseObject[@"status"] integerValue];
            NSDictionary *userInfo =
            @{
              NSLocalizedDescriptionKey: @"Layer Identity Provider Returned an Error.",
              NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with your APPID."
              };
            
            NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
            completion(nil, error);
        }
        
    }] resume];
}



@end
