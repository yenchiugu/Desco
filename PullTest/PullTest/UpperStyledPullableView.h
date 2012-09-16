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
  NSString *_user_img_path1;
  NSString *_user_img_path2;
  NSString *_user_img_path3;
  NSString *_user_img_path4;
  NSString *_user_img_path5;
  NSString *_user_img_path6;
  NSString *_user_img_path7;
  NSString *_user_img_path8;
  NSString *_user_img_path9;
  NSString *_user_img_path10;
    __gm_weak GMGridView *_gmGridView;
  GMGridViewCell *_animatedCell;
}

@end
