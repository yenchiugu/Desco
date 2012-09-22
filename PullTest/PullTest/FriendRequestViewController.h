//
//  FriendRequestViewController.h
//  PullTest
//
//  Created by Sam Ku on 9/22/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendRequestDelegate;

@interface FriendRequestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *friendLable;
@property (weak) NSObject<FriendRequestDelegate> *delegate;
- (IBAction)ClickAcceptBtn:(id)sender;
@end

@protocol FriendRequestDelegate <NSObject>

@optional
- (void)ClickAcceptBtn:(UIViewController*) uiview;


@end