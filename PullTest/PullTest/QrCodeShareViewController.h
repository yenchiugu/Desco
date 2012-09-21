//
//  QrCodeShareViewController.h
//  PullTest
//
//  Created by Sam Ku on 9/21/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QrCodeShareDelegate;

@interface QrCodeShareViewController : UIViewController
@property (strong) IBOutlet UIImageView *imgView;
- (IBAction)ClickDesktopDescoBtn:(id)sender;
@property (weak) NSObject<QrCodeShareDelegate> *delegate;
@end

@protocol QrCodeShareDelegate <NSObject>

@optional
- (void)ClickDesktopDescoBtn:(UIViewController*) uiview;


@end