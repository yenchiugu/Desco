//
//  QuestionSendViewController.h
//  PullTest
//
//  Created by Sam Ku on 9/20/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionSendDelegate;

@interface QuestionSendViewController : UIViewController
- (IBAction)ClickYesBtn:(id)sender;
- (IBAction)ClickNoBtn:(id)sender;

//@property  (strong) IBOutlet UIButton *yesBtn;
@property (weak) NSObject<QuestionSendDelegate> *delegate;

@end


@protocol QuestionSendDelegate <NSObject>

@optional
- (void)ClickSendYesBtn:(UIViewController*) uiview;
- (void)ClickSendNoBtn:(UIViewController*) uiview;

@end