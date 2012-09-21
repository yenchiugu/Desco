//
//  chatBoardView.m
//  PullTest
//
//  Created by Ace Wu on 12/9/22.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "ChatBoardView.h"

@interface ChatBoardView ()
{
    NSArray *images;
    NSInteger currentIndex;
}
@end

@implementation ChatBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        images = [NSArray arrayWithObjects:
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
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[images objectAtIndex:currentIndex]]];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentIndex = (currentIndex + 1) % [images count];
    self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[images objectAtIndex:currentIndex]]];
}

@end
