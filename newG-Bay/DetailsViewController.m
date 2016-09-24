//
//  DetailsViewController.m
//  G-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "DetailsViewController.h"
#import "AHTagTableViewCell.h"
#import "TagGroups.h"
#import <Social/Social.h>

@interface DetailsViewController (){
    NSArray<NSArray<AHTag *> *> *_dataSource;
}


@end

@implementation DetailsViewController



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

-(void)viewWillAppear:(BOOL)animated
{
    self.noticeToast = [[SWBufferedToast alloc] initNoticeToastWithTitle:@"Loading"
                                                                subtitle:@"Please wait while loading data!"
                                                           timeToDisplay:120
                                                        backgroundColour:nil
                                                              toastColor:self.candyCaneRed
                                                     animationImageNames:nil
                                                                  onView:self.view];
    [self.noticeToast appear];
    [self.noticeToast beginLoading];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.foundTokenView.hidden = self.ishidden;
    self.totalGBalance.text = self.GBalanceText;
    
    _dataSource = [TagGroups dataSource:[NSMutableString stringWithString:self.category]];
    
    
    self.locationDetail = [[TGFoursquareLocationDetail alloc] initWithFrame:self.view.bounds];
    self.locationDetail.tableViewDataSource = self;
    self.locationDetail.tableViewDelegate = self;
    
    self.locationDetail.delegate = self;
    self.locationDetail.parallaxScrollFactor = 0.3; // little slower than normal.
    
    [self.view addSubview:self.locationDetail];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view bringSubviewToFront:self.headerView];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.frame = CGRectMake(10, 22, 44, 44);
    [buttonBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    self.locationDetail.headerView = self.headerView;
    
    
    // TODO: Switch this URL to your own authenticated API
    NSURL *clientTokenURL = [NSURL URLWithString:@"https://braintree-sample-merchant.herokuapp.com/client_token"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:clientTokenRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle errors
        NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
        // As an example, you may wish to present our Drop-in UI at this point.
        // Continue to the next section to learn more...
    }] resume];
    NSString *clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJjNDZlMjdkMjBhZjA0NDBhNjM0YzBiZWQzZjMzYWVlNDM5ZjMwOWIwYmMzOTM1Njc2NzA2ZmVlYjM4NGU1NTljfGNyZWF0ZWRfYXQ9MjAxNi0wOS0wN1QwMzo0OToyNS4wMjM5ODczMDErMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJjb2luYmFzZUVuYWJsZWQiOmZhbHNlLCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=";


}



#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 138.0f;
    }
    else if(indexPath.row == 1){
        return 171.0f;
    }
    else if(indexPath.row == 3){
        if ([self.category length] <= 7) {
            return 75.0f;
        } else if ([self.category length] <= 14) {
            return 150.0f;
        } else if ([self.category length] <= 24) {
            return 225.0f;
        } else {
            return 100.0;
        }
    }
    else if(indexPath.row == 4 || indexPath.row == 5) {
        return 175.0f;
    }
    else
        return 100.0f; //cell for comments, in reality the height has to be adjustable
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        DetailLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailLocationCell"];
        
        if(cell == nil){
            cell = [DetailLocationCell detailLocationCell];
            cell.lblTitle.text = self.titled;
            cell.lblRate.text = [NSString stringWithFormat:@"$%@", self.price];
            cell.lblDescription.text = [NSString stringWithFormat:@"Condition: %@", self.condition];
            [cell.btnSave addTarget:self action:@selector(buyNow) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnCheckin addTarget:self action:@selector(watchForLater) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    else if(indexPath.row == 1){
        AddressLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressLocationDetail"];
        
        if(cell == nil){
            cell = [AddressLocationCell addressLocationDetailCell];
            CLLocation *location = [[CLLocation alloc]
                                    initWithLatitude:_locationLat
                                    longitude:_locationLon];
        
            CLGeocoder* geocoder = [[CLGeocoder alloc] init];
            [geocoder
             reverseGeocodeLocation:location
             completionHandler:^(NSArray *placemarks, NSError *error) {
        
                 CLPlacemark *placemark = [placemarks lastObject];
                 NSString *address = [NSString stringWithFormat:@"%@ %@ %@, %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea];
                 cell.streetAddress.text = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
                 cell.cityAddress.text = placemark.locality;
                 cell.stateAddress.text = placemark.administrativeArea;
                 
                 //LOADING ENDS HERE
                 [self.noticeToast dismiss];
                 
             }];
            
            _map = [[MKMapView alloc] initWithFrame:CGRectMake(219, 0, 156, 171)];
            _map.userInteractionEnabled = FALSE;
            _map.delegate = self;
            MKCoordinateRegion myRegion;
            
            myRegion.center.latitude = _locationLat;
            myRegion.center.longitude = _locationLon;
            
            // this sets the zoom level, a smaller value like 0.02
            // zooms in, a larger value like 80.0 zooms out
            myRegion.span.latitudeDelta = 0.2;
            myRegion.span.longitudeDelta = 0.2;
            
            // move the map to our location
            [_map setRegion:myRegion animated:NO];
            
            //annotation
            TGAnnotation *annot = [[TGAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(_locationLat, _locationLon)];
            [_map addAnnotation:annot];
            
            
            [cell.contentView addSubview:_map];
        }
        
        return cell;
    }
    else if(indexPath.row == 2){
        TipCells *cell = [tableView dequeueReusableCellWithIdentifier:@"tipCells"];
        
        if(cell == nil){
            cell = [TipCells tipCells];
            cell.titleLbl.text = @"Item Description:";
            cell.contentLbl.text = self.dataDescription;
            cell.contentLbl.numberOfLines = 0;
            [cell.contentLbl sizeToFit];
        }
        return cell;
    }
    else if(indexPath.row == 3){
        TipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tipCell"];
        
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"AHTagTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"cell"];
            cell = [TipCell tipCell];
            cell.titleLbl.text = @"Categories: ";
            cell.contentLbl.text = nil;
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
        }
        return cell;
    }
    else if(indexPath.row == 4){
        TipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tipCell"];
        
        if(cell == nil){
            cell = [TipCell tipCell];
            cell.titleLbl.text = @"Prefrences:";
            cell.contentLbl.text = [NSString stringWithFormat:@"Payment Method: %@\n\nHandling Time: %@\n\nReturns: %@", self.paymentMethod,self.handlingTime,self.returns];
            cell.contentLbl.frame = CGRectMake(cell.contentLbl.frame.origin.x, cell.contentLbl.frame.origin.y, cell.contentLbl.frame.size.width, 120);
        }
        return cell;
    }
    else if(indexPath.row == 5){
        TipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tipCell"];
        
        if(cell == nil){
            cell = [TipCell tipCell];
            cell.titleLbl.text = @"Shipping/Handling:";
            cell.contentLbl.text = [NSString stringWithFormat:@"Type of Delivery: %@\n\nShipping/Handling Cost: %@\n\nShipping Service: %@", self.deliveryType,self.shippingCosts,self.shippingService];
            cell.contentLbl.frame = CGRectMake(cell.contentLbl.frame.origin.x, cell.contentLbl.frame.origin.y, cell.contentLbl.frame.size.width, 120);
        }
        return cell;
    }
    else if(indexPath.row == 6){
        MediaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell"];
        
        if(cell == nil){
            cell = [MediaCell mediaCell];
            cell.titleLbl.text = @"Share on Social Media:";
            [cell.twitterButton addTarget:self action:@selector(twitterAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.faceBookButton addTarget:self action:@selector(facebookAction) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusable"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reusable"];
        }
        
        cell.textLabel.text = @"Default cell";
        
        return cell;
    }
}

- (void)configureCell:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if (![object isKindOfClass:[AHTagTableViewCell class]]) {
        return;
    }
    AHTagTableViewCell *cell = (AHTagTableViewCell *)object;
    cell.label.tags = _dataSource[0];
    cell.label.userInteractionEnabled = NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - LocationDetailViewDelegate

- (void)locationDetail:(TGFoursquareLocationDetail *)locationDetail imagePagerDidLoad:(KIImagePager *)imagePager
{
    imagePager.dataSource = self;
    imagePager.delegate = self;
    imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    imagePager.slideshowTimeInterval = 0.0f;
    imagePager.slideshowShouldCallScrollToDelegate = YES;
    
    //self.locationDetail.nbImages = [self.locationDetail.imagePager.dataSource.arrayWithImages count];
    if (_itemImage.count == 0) {
        self.locationDetail.nbImages = 1;
    } else {
        self.locationDetail.nbImages = _itemImage.count;
    }
    self.locationDetail.currentImage = 0;
}

- (void)locationDetail:(TGFoursquareLocationDetail *)locationDetail tableViewDidLoad:(UITableView *)tableView
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)locationDetail:(TGFoursquareLocationDetail *)locationDetail headerViewDidLoad:(UIView *)headerView
{
    [headerView setAlpha:0.0];
    [headerView setHidden:YES];
}

#pragma mark - MKMap View methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *MyPinAnnotationIdentifier = @"Pin";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier:MyPinAnnotationIdentifier];
    if (!pinView){
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:MyPinAnnotationIdentifier];
        
        UIGraphicsBeginImageContext(CGSizeMake(50, 50));
        [[UIImage imageNamed:@"pinAnnotation"] drawInRect:CGRectMake(0, 0, 50, 50)];
        UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        annotationView.image = destImage;
        
        return annotationView;
        
    }else{
        
        UIGraphicsBeginImageContext(CGSizeMake(50, 50));
        [[UIImage imageNamed:@"pinAnnotation"] drawInRect:CGRectMake(0, 0, 50, 50)];
        UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        pinView.image = destImage;
        
        return pinView;
    }
    
    return nil;
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages
{
    if (_itemImage.count == 0) {
        return @[@"https://irs2.4sqi.net/img/general/500x500/2514_BvEN_Q6lG50xZQ9TIG0XY8eYXzF3USSMdtTmxHCmqnE.jpg"];
    }
    return _itemImage;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFill;
}

//- (NSString *) captionForImageAtIndex:(NSUInteger)index
//{
//    return @[@"Image 1"][index];
//}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

#pragma mark - Button actions

- (void)back
{
//    NSLog(@"Here you should go back to previous view controller");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // when your application opens:
    NSString * viewIdentifierString = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"last_view"];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifierString];

    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
    // If you haven't already, create and retain a `BTAPIClient` instance with a tokenization
    // key or a client token from your server.
    // Typically, you only need to do this once per session.
     NSString *clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJjNDZlMjdkMjBhZjA0NDBhNjM0YzBiZWQzZjMzYWVlNDM5ZjMwOWIwYmMzOTM1Njc2NzA2ZmVlYjM4NGU1NTljfGNyZWF0ZWRfYXQ9MjAxNi0wOS0wN1QwMzo0OToyNS4wMjM5ODczMDErMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJjb2luYmFzZUVuYWJsZWQiOmZhbHNlLCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=";
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
    
    // Create a BTDropInViewController
//    PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
//                                    withQuantity:2
//                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
//                                    withCurrency:@"USD"
//                                         withSku:@"Hip-00037"];
//    PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
//                                    withQuantity:1
//                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
//                                    withCurrency:@"USD"
//                                         withSku:@"Hip-00066"];
//    PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
//                                    withQuantity:1
//                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
//                                    withCurrency:@"USD"
//                                         withSku:@"Hip-00291"];
//    NSArray *items = @[item1, item2, item3];
//    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
//     Optional: include payment details
//    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
//    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
//    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
//                                                                               withShipping:shipping
//                                                                                    withTax:tax];
//    
//    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
//    
//    PayPalPayment *payment = [[PayPalPayment alloc] init];
//    payment.amount = total;
//    payment.currencyCode = @"USD";
//    payment.shortDescription = @"Hipster clothing";
//    payment.items = items;  // if not including multiple items, then leave payment.items as nil
//    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
//    
//    if (!payment.processable) {
//        // This particular payment will always be processable. If, for
//        // example, the amount was negative or the shortDescription was
//        // empty, this payment wouldn't be processable, and you'd want
//        // to handle that here.
//    }
//    
//    // Update payPalConfig re accepting credit cards.
//    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
//    
//    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
//                                                                                                configuration:self.payPalConfig
//                                                                                                     delegate:self];
//    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (void)post
{
    NSLog(@"Post action");
}

- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    // Send payment method nonce to your server for processing
    [self postNonceToServer:paymentMethodNonce.nonce];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    // Update URL with your server
    NSURL *paymentURL = [NSURL URLWithString:@"https://your-server.example.com/checkout"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:paymentURL];
    request.HTTPBody = [[NSString stringWithFormat:@"payment_method_nonce=%@", paymentMethodNonce] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle success and failure
        if (error) {
            NSLog(@"Error");
        } else {
            NSLog(@"Success");
        }
    }] resume];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
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
-(void)twitterAction {
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:[NSString stringWithFormat:@"Check out %@ on G-Bay!", self.titled]];
    if (self.itemImage.count == 0) {
        [tweetSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://irs2.4sqi.net/img/general/500x500/2514_BvEN_Q6lG50xZQ9TIG0XY8eYXzF3USSMdtTmxHCmqnE.jpg"]]]];
    } else {
        [tweetSheet addImage:self.itemImage[0]];
    }
    [self presentViewController:tweetSheet animated:YES completion:nil];
}
-(void)facebookAction {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:[NSString stringWithFormat:@"Check out %@ on G-Bay!", self.titled]];
    if (self.itemImage.count == 0) {
        [controller addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://irs2.4sqi.net/img/general/500x500/2514_BvEN_Q6lG50xZQ9TIG0XY8eYXzF3USSMdtTmxHCmqnE.jpg"]]]];
    } else {
        [controller addImage:self.itemImage[0]];
    }
    [self presentViewController:controller animated:YES completion:Nil];
}


-(void)buyNow { 
    NSLog(@"Buy Now");
}
-(void)watchForLater {
    NSLog(@"Watch for Later");
}



@end
