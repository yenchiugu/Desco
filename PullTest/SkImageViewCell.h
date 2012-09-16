//
//  SkImageViewCell.h
//  PullTest
//
//  Created by Sam Ku on 9/14/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "AQGridViewCell.h"

@interface SkImageViewCell : AQGridViewCell {
  
  UIImageView * _imageView;
}
@property (nonatomic, strong) UIImage * image;
@end
