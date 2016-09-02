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
    else
        return 100.0f; //cell for comments, in reality the height has to be adjustable
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
//    else if(indexPath.row == 4){
//        TipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tipCell"];
//        
//        if(cell == nil){
//            cell = [TipCell tipCell];
//            cell.titleLbl.text = @"Brian B. says:";
//            cell.contentLbl.text = @"Awesome City and Country, great people...";
//        }
//        return cell;
//    }
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
    
    self.locationDetail.nbImages = [self.locationDetail.imagePager.dataSource.arrayWithImages count];
    self.locationDetail.currentImage = 0;
    //[imagePager updateCaptionLabelForImageAtIndex:self.locationDetail.currentImage];
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
    return @[
             @"https://irs2.4sqi.net/img/general/500x500/2514_BvEN_Q6lG50xZQ9TIG0XY8eYXzF3USSMdtTmxHCmqnE.jpg",
             @"https://irs3.4sqi.net/img/general/500x500/6555164_Rkk21OJj4X54X8bkutzxbeCwLHTA8Hrre6_wUVc1DMg.jpg",
             @"https://irs2.4sqi.net/img/general/500x500/3648632_NVZOdXiRTkVtzHoGNh5c5SqsF2NxYDB_FMfXRCbYu6I.jpg",
             @"https://irs1.4sqi.net/img/general/500x500/23351702_KoUKj6hZLOTHIsawxi2L64O5CpJwCadeIv2daMBDE8Q.jpg"
             ];
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image
{
    return UIViewContentModeScaleAspectFill;
}

- (NSString *) captionForImageAtIndex:(NSUInteger)index
{
    return @[
             @"First screenshot",
             @"Another screenshot",
             @"And another one",
             @"Last one! ;-)"
             ][index];
}

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
    NSLog(@"Here you should go back to previous view controller");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // when your application opens:
    NSString * viewIdentifierString = [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"last_view"];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewIdentifierString];

    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:viewController
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
}

- (void)post
{
    NSLog(@"Post action");
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

@end
