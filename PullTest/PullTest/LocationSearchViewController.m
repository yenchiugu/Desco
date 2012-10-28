//
//  LocationSearchViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/21/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "LocationSearchViewController.h"
#import "LocationSearchFilePin.h"
#import "SKLocationFileInfo.h"
#import "SKViewController.h"
@interface LocationSearchViewController ()

@end

@implementation LocationSearchViewController
@synthesize mapView;
@synthesize mainController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    mapView.delegate = self;
        NSString *location_path = @"/user/location_share";
    [self.mainController.dbManager.restClient loadMetadata:location_path];
    //[self showCurrentLocation];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  [self showCurrentLocation];
    //NSString *location_path = @"/user/location_share";
    //[self.mainController.dbManager.restClient loadMetadata:location_path];
//  static int got = 0;
//  
//  if (got==0) {
//    [self setViewMapPin];
//    got=1;
//  }

  
}

- (void)showCurrentLocation {
  //取得現在位置
  double X = mapView.userLocation.location.coordinate.latitude;
  double Y = mapView.userLocation.location.coordinate.longitude;
  
  
  //自行定義的設定地圖函式
  [self setMapRegionLongitude:Y andLatitude:X withLongitudeSpan:0.0045 andLatitudeSpan:0.0045];
}


- (void)setMapRegionLongitude:(double)Y andLatitude:(double)X withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX {
  
  //設定經緯度
  CLLocationCoordinate2D mapCenter;
  mapCenter.latitude = X;
  mapCenter.longitude = Y;
  
  //Map Zoom設定
  MKCoordinateSpan mapSpan;
  mapSpan.latitudeDelta = SX;
  mapSpan.longitudeDelta = SY;
  
  //設定地圖顯示位置
  MKCoordinateRegion mapRegion;
  mapRegion.center = mapCenter;
  mapRegion.span = mapSpan;
  
  //前往顯示位置
  [mapView setRegion:mapRegion];
  [mapView regionThatFits:mapRegion];
}

- (void)setViewMapPin:(NSMutableArray*) loc_info_array {
    NSLog(@"[setViewMapPin] %@",loc_info_array);
    
    //宣告一個陣列來存放標籤
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (SKLocationFileInfo *loc_info in loc_info_array) {
        CLLocationCoordinate2D pinCenter;
        pinCenter.latitude = loc_info.latitude ;
        pinCenter.longitude = loc_info.longitude;
        
        //建立一個地圖標籤並設定內文
        LocationSearchFilePin *pin = [[LocationSearchFilePin alloc]initWithCoordinate:pinCenter];
        pin.title = loc_info.filename;
        
        NSString *desc= [NSString stringWithFormat:@"Shared by %@, keep for %d hours",loc_info.username,loc_info.keepHours ];
        pin.subtitle = desc;
        
        [annotations addObject:pin];
    }
    
    //將陣列中所有的標籤顯示在地圖上
    [mapView removeAnnotations:[mapView annotations]];
    [mapView addAnnotations:annotations];
}

//自行定義設定地圖標籤的函式
- (void)setViewMapPin {
  
  //宣告一個陣列來存放標籤
  NSMutableArray *annotations = [[NSMutableArray alloc] init];
  
  for (int i = 1; i <= 1; i++) {
    
    //隨機設定標籤的緯度
    CLLocationCoordinate2D pinCenter;
    //取得現在位置
    double X = mapView.userLocation.location.coordinate.latitude;
    double Y = mapView.userLocation.location.coordinate.longitude;
    pinCenter.latitude = X ;
    pinCenter.longitude = Y + 0.0001f;
    
    //建立一個地圖標籤並設定內文
    LocationSearchFilePin *pin = [[LocationSearchFilePin alloc]initWithCoordinate:pinCenter];
    pin.title = @"20111222.MTS";
    pin.subtitle = @"Ace's iPad, Password: No";
    
    //將製作好的標籤放入陣列中
    [annotations addObject:pin];

  }
  
  //將陣列中所有的標籤顯示在地圖上
  [mapView removeAnnotations:annotations];
  [mapView addAnnotations:annotations];

}
- (IBAction)ClickSaveBtn:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(ClickSaveBtn:)]) {
    [self.delegate ClickSaveBtn:self];
  }
  
}
@end
