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

@interface SKViewController : UIViewController <PullableViewDelegate, NGTabBarControllerDelegate,QuestionSendDelegate>
{
}
@property (strong) UpperStyledPullableView *upperView;
@property (strong) StyledPullableView *bottomView;
@property (strong) NGTabBarController *tabBarController;
@property (strong) QuestionSendViewController *questionSendViewController;
@end
