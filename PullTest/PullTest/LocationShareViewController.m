//
//  LocationShareViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/21/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "LocationShareViewController.h"
#import "MJPopupViewController/UIViewController+MJPopupViewController.h"
@interface LocationShareViewController ()

@end

@implementation LocationShareViewController
@synthesize mapView;
@synthesize hourLabel;
@synthesize mainView;
@synthesize delegate;
@synthesize latitude;
@synthesize longitude;
@synthesize targetFileName;
@synthesize keepHours;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView {
  [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   // [self showCurrentLocation];
  mapView.delegate = self;

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

- (IBAction)ClickShareNowBtn:(id)sender {
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(ClickShareNowBtn:)]) {
    [self.delegate ClickShareNowBtn:self];
  }
   // [mainView dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];
}

- (IBAction)ClickCancelBtn:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(ClickCancelBtn:)]) {
    [self.delegate ClickCancelBtn:self];
  }
  //  [mainView dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  [self showCurrentLocation];

}

- (void)showCurrentLocation {
  //取得現在位置
  double X = mapView.userLocation.location.coordinate.latitude;
  double Y = mapView.userLocation.location.coordinate.longitude;

    latitude = X;
    longitude = Y;
    
  keepHours = 1;
  //自行定義的設定地圖函式
  [self setMapRegionLongitude:Y andLatitude:X withLongitudeSpan:0.0045 andLatitudeSpan:0.0045];
}

- (IBAction)HourSliderChanged:(id)sender {
  UISlider *my_slider=  (UISlider*)sender;
  NSString *label_str = [NSString stringWithFormat:@"%d",(int)my_slider.value];
  keepHours = (int)my_slider.value;
  [hourLabel setText:label_str];
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
@end
