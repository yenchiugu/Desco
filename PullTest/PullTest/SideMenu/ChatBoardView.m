//
//  chatBoardView.m
//  PullTest
//
//  Created by Ace Wu on 12/9/22.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "ChatBoardView.h"

@implementation ChatBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"chat_board.png"]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
