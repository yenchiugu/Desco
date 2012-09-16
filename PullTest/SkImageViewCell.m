//
//  SkImageViewCell.m
//  PullTest
//
//  Created by Sam Ku on 9/14/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "SkImageViewCell.h"

@implementation SkImageViewCell

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
  self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
  if (self) {
      // Initialization code
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageView];
  }
  return self;
}

- (CALayer *) glowSelectionLayer
{
  return ( _imageView.layer );
}

- (UIImage *) image
{
  return ( _imageView.image );
}

- (void) setImage: (UIImage *) anImage
{
  _imageView.image = anImage;
  [self setNeedsLayout];
}

- (void) layoutSubviews
{
  [super layoutSubviews];
  
  CGSize imageSize = _imageView.image.size;
  CGRect frame = _imageView.frame;
  CGRect bounds = self.contentView.bounds;
  
  if ( (imageSize.width <= bounds.size.width) &&
      (imageSize.height <= bounds.size.height) )
  {
    return;
  }
  
  // scale it down to fit
  CGFloat hRatio = bounds.size.width / imageSize.width;
  CGFloat vRatio = bounds.size.height / imageSize.height;
  CGFloat ratio = MAX(hRatio, vRatio);
  
  frame.size.width = floorf(imageSize.width * ratio);
  frame.size.height = floorf(imageSize.height * ratio);
  frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
  frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
  _imageView.frame = frame;
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
