//
//  SKThumbnailImgUtils.h
//  PullTest
//
//  Created by Sam Ku on 12/10/27.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKThumbnailImgUtils : NSObject

+(NSString*) getDocPath;
+(NSString*) getCurrentDateTimeString;
+(void) saveImage:(UIImage*) img;
+(void) saveImage:(UIImage*) img fileNmae:(NSString*)filename ;
+ (UIImage*) openThumbnailImg:(NSString*) filename ;
+ (UIImage*) openOrCreateThumbnailImg:(NSString*) filename imgSize:(CGSize) size;
+ (UIImage*) openThumbnailImgFromIndex:(NSInteger) index
                           outFileName:(NSString**) filename;
+ (UIImage*) openOrCreateThumbnailImgFromIndex:(NSInteger) index
                                       ImgSize:(CGSize)size
                                   outFileName:(NSString**) filename;
+(NSInteger) getFileCount;
+(BOOL) isExclusiveFolders:(NSString*) path;
@end
