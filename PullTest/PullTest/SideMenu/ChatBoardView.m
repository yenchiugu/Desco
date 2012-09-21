//
//  chatBoardView.m
//  PullTest
//
//  Created by Ace Wu on 12/9/22.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ChatBoardView.h"

@interface ChatBoardView ()
{
    NSArray *image_paths;
    NSInteger currentIndex;
}
@end

@implementation ChatBoardView

@synthesize chatInput = _chatInput;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        image_paths = [NSArray arrayWithObjects:
                 @"chat board_act3-1.png",
                 @"chat board_act3-2.png",
                 @"chat board_act4-1.png",
                 @"chat board_act4-2.png",
                 @"chat board_act4-3.png",
                 @"chat board_act5-1.png",
                 @"chat board_act5-2.png",
                 @"chat board_act5-3.png",
                 nil];
        currentIndex = 0;
        self.alpha = 0.0f;
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[image_paths objectAtIndex:currentIndex]]];
    
        chatInput = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 500, 100)];
        chatInput.center = CGPointMake(self.center.x, self.center.y * 1.3f);
        chatInput.alpha = 0.7f;
        [[chatInput layer] setCornerRadius:20];
        [[chatInput layer] setBorderWidth:4.0f];
        [[chatInput layer] setBorderColor:[[UIColor colorWithRed:0.2f green:0.3f blue:0.8f alpha:1] CGColor]];
        [chatInput setFont:[UIFont boldSystemFontOfSize:26.0f]];
        [self addSubview:chatInput];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentIndex = (currentIndex + 1) % [image_paths count];
    self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[image_paths objectAtIndex:currentIndex]]];
}

@end
