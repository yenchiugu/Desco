//
//  LocationSearchViewController.h
//  PullTest
//
//  Created by Sam Ku on 9/21/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@class SKViewController;
@protocol LocationSearchDelegate;

@interface LocationSearchViewController : UIViewController <MKMapViewDelegate>


@property (strong) IBOutlet MKMapView *mapView;
@property (weak) NSObject<LocationSearchDelegate> *delegate;
@property (weak) SKViewController *mainController;
- (IBAction)ClickSaveBtn:(id)sender;
- (void)setViewMapPin:(NSMutableArray*) loc_info_array;

@end

@protocol LocationSearchDelegate <NSObject>

@optional
- (void)ClickSaveBtn:(UIViewController*) uiview;


@end