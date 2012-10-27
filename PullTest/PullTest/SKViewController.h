//
//  SKViewController.h
//  PullTest
//
//  Created by Sam Ku on 9/9/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullableView.h"
#import "StyledPullableView.h"
#import "UpperStyledPullableView.h"
#import "NGTabBarController/NGTabBarController.h"
#import "NGTabBarController/NGTabBarControllerDelegate.h"
#import "QuestionSendViewController.h"
#import "LocationShareViewController.h"
#import "QrCodeShareViewController.h"
#import "LocationSearchViewController.h"
#import "FriendRequestViewController.h"
#import "SKStuffViewController.h"

#import "SideMenu/FileQueueViewController.h"
#import "SideMenu/ChatBoardView.h"

#import "TouchTracker/TouchTracker.h"
#import "DropboxManager/DropboxManager.h"


@interface SKViewController : UIViewController <
        PullableViewDelegate,
        NGTabBarControllerDelegate,
        QuestionSendDelegate,
        QrCodeShareDelegate,
        LocationShareDelegate,
        LocationSearchDelegate,
        FriendRequestDelegate,
        DropboxManagerDelegate>
{
    TouchTracker *touchTracker;
    FileQueueViewController *fileQueueMenu;
    UIPopoverController *fileQueuePopover;
    UIView *sharingMenu;
    ChatBoardView *chatBoard;
    DropboxManager *dbManager;
    FileQueueViewController *fileQueueViewController;
}
@property (nonatomic,strong) UpperStyledPullableView *upperView;
@property (nonatomic,strong) StyledPullableView *bottomView;
@property (nonatomic,strong) NGTabBarController *tabBarController;
@property (nonatomic,strong) QuestionSendViewController *questionSendViewController;
@property (nonatomic,strong) UIButton *locationShareButton;
@property (nonatomic,strong) LocationShareViewController *locationViewController;
@property (nonatomic,strong) UIButton *qrCodeShareButton;
@property (nonatomic,strong) QrCodeShareViewController *qrCodeViewController;
@property (nonatomic,strong) LocationSearchViewController *locationSearchViewController;
@property (nonatomic,strong) FriendRequestViewController *friendRequestViewController;
@property (nonatomic,strong) SKStuffViewController *my_stuff_view_controllor;
@property (nonatomic,strong) DropboxManager *dbManager;
@property (nonatomic,strong) FileQueueViewController *fileQueueViewController;
@end
