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

@property (weak, nonatomic) id<QuestionSendDelegate> delegate;
@property (strong, nonatomic) NSString *srcFile;
@property (strong, nonatomic) NSString *toUser;
//@property  (strong) IBOutlet UIButton *yesBtn;

- (IBAction)ClickYesBtn:(id)sender;
- (IBAction)ClickNoBtn:(id)sender;
- (void)clear;
@end


@protocol QuestionSendDelegate <NSObject>

@optional
- (void)ClickSendYesBtn:(UIViewController*) uiview;
- (void)ClickSendNoBtn:(UIViewController*) uiview;
@end