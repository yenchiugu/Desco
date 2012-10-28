//
//  UpperStyledPullableView.h
//  PullTest
//
//  Created by Sam Ku on 9/15/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "PullableView.h"
#import "GMGridView.h"
@interface UpperStyledPullableView : PullableView <GMGridViewDataSource, SKDragEvent, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
}

@property (atomic,weak) GMGridView *_gmGridView;
@end
