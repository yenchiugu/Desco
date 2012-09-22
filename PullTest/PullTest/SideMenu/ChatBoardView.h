//
//  chatBoardView.h
//  PullTest
//
//  Created by Ace Wu on 12/9/22.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatBoardView : UIView
{
    UITextView *chatInput;
    UIButton *sendButton;
}
@property (strong, nonatomic) UITextView *chatInput;
@property (strong, nonatomic) UIButton *sendButton;
@end
