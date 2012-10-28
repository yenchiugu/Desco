//
//  LocationShareViewController.h
//  PullTest
//
//  Created by Sam Ku on 9/21/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@protocol LocationShareDelegate;

@interface LocationShareViewController : UIViewController <MKMapViewDelegate>

@property (strong) IBOutlet MKMapView *mapView;
@property (strong) IBOutlet UILabel *hourLabel;
@property (weak) UIViewController *mainView;
@property (weak) NSObject<LocationShareDelegate> *delegate;
@property (strong, atomic) NSString *targetFileName;
@property ( atomic) double longitude;
@property ( atomic) double latitude;
@property (atomic)  int keepHours;

- (IBAction)ClickShareNowBtn:(id)sender;
- (IBAction)ClickCancelBtn:(id)sender;
- (void)showCurrentLocation;
- (IBAction)HourSliderChanged:(id)sender;
- (void)setMapRegionLongitude:(double)Y andLatitude:(double)X withLongitudeSpan:(double)SY andLatitudeSpan:(double)SX;
@end

@protocol LocationShareDelegate <NSObject>

@optional
- (void)ClickShareNowBtn:(UIViewController*) uiview;
- (void)ClickCancelBtn:(UIViewController*) uiview;

@end