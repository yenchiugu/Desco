//
//  UIImage+SKScalableUImage.h
//  PullTest
//
//  Created by Sam Ku on 12/10/21.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SKScalableUImage)
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToFitSize:(CGSize)size;

@end
