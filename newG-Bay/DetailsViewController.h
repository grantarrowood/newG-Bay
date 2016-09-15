//
//  DetailsViewController.h
//  G-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TGFoursquareLocationDetail.h"
#import "DetailLocationCell.h"
#import "AddressLocationCell.h"
#import "TipCell.h"
#import "TipCells.h"
#import "MediaCell.h"
#import "TGAnnotation.h"
#import "MainViewController.h"
#import "SlideNavigationController.h"
#import "BraintreeCore.h"
#import "BraintreeUI.h"
#import "SWBufferedToast.h"


@interface DetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,TGFoursquareLocationDetailDelegate, KIImagePagerDelegate, KIImagePagerDataSource, CLLocationManagerDelegate, BTDropInViewControllerDelegate>


@property (nonatomic, strong) SWBufferedToast *noticeToast;

@property (nonatomic, strong) BTAPIClient *braintreeClient;

@property(nonatomic) NSString* titled;
@property(nonatomic) NSMutableString* dataDescription;
@property(nonatomic) NSString* condition;
@property(nonatomic) NSNumber* price;
@property(nonatomic) NSString* category;
@property(nonatomic) NSString* paymentMethod;
@property(nonatomic) NSString* handlingTime;
@property(nonatomic) NSString* returns;
@property(nonatomic) NSString* deliveryType;
@property(nonatomic) NSString* shippingCosts;
@property(nonatomic) NSString* shippingService;
@property(nonatomic) NSString* GBalanceText;
@property(nonatomic) NSArray* itemImage;
@property(nonatomic) int theid;
@property(nonatomic) double locationLat;
@property(nonatomic) double locationLon;
@property(nonatomic) bool ishidden;
@property (weak, nonatomic) IBOutlet UIView *foundTokenView;
@property (weak, nonatomic) IBOutlet UILabel *totalGBalance;



@property (nonatomic, strong) TGFoursquareLocationDetail *locationDetail;
@property (nonatomic, strong) MKMapView *map;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;


@end
