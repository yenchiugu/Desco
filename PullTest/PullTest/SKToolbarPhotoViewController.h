//
//  SKToolbarPhotoViewController.h
//  PullTest
//
//  Created by Sam Ku on 12/10/26.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "NIToolbarPhotoViewController.h"

@interface SKToolbarPhotoViewController : NIToolbarPhotoViewController
<NIPhotoAlbumScrollViewDataSource,
NIPhotoScrubberViewDataSource> {
    __weak UINavigationController *my_navigationController;
}

@property (nonatomic,weak) UINavigationController *my_navigationController;
@property (nonatomic) NSInteger select_index;
@end
