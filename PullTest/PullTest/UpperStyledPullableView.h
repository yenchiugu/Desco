//
//  UpperStyledPullableView.h
//  PullTest
//
//  Created by Sam Ku on 9/15/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "PullableView.h"
#import "GMGridView.h"
@interface UpperStyledPullableView : PullableView<GMGridViewDataSource,SKDragEvent>  {
  NSString *_user_img_path01;
  NSString *_user_img_path02;
  NSString *_user_img_path03;
  NSString *_user_img_path04;
  NSString *_user_img_path05;
  NSString *_user_img_path06;
  NSString *_user_img_path07;
  NSString *_user_img_path08;
  NSString *_user_img_path09;
  NSString *_user_img_path10;
    __gm_weak GMGridView *_gmGridView;
  GMGridViewCell *_animatedCell;
}

@end
