//
//  UIImage+SKScalableUImage.m
//  PullTest
//
//  Created by Sam Ku on 12/10/21.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "UIImage+SKScalableUImage.h"

@implementation UIImage (SKScalableUImage)

- (UIImage *)imageScaledToSize:(CGSize)size
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

- (UIImage *)imageScaledToFitSize:(CGSize)size
{
    //calculate rect
    CGFloat aspect = self.size.width / self.size.height;
    if (size.width / aspect <= size.height)
    {
        return [self imageScaledToSize:CGSizeMake(size.width, size.width / aspect)];
    }
    else
    {
        return [self imageScaledToSize:CGSizeMake(size.height * aspect, size.height)];
    }
}
@end
