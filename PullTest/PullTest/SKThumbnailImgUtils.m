//
//  SKThumbnailImgUtils.m
//  PullTest
//
//  Created by Sam Ku on 12/10/27.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "SKThumbnailImgUtils.h"
#import "UIImage+SKScalableUImage.h"
#import "UIImage+fixOrientation.h"
#import "UIImage-Categories/UIImage+Resize.h"

@implementation SKThumbnailImgUtils


+(NSString*) getDocPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}


+(NSString*) getCurrentDateTimeString {
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"'img_'yyyyddMMHHmmss'.png'"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

#pragma mark Image Methods

+(void) saveImage:(UIImage*) img {
    NSString *doc_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *current_time_string = [self getCurrentDateTimeString];
    NSString *path_path = [doc_path stringByAppendingPathComponent:current_time_string];
    
    img = [img fixOrientation];
    NSLog(@"saveImage: %@",path_path);
    BOOL result = [UIImagePNGRepresentation(img) writeToFile:path_path atomically:YES];
    NSLog(@"saveImage result:%d",result);
    
//    [_gmGridView reloadData];
}

+(void) saveImage:(UIImage*) img fileNmae:(NSString*)filename {
    NSString *doc_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString *path_path = [doc_path stringByAppendingPathComponent:filename];
    
    //img = [img fixOrientation];
    NSLog(@"saveImage: %@",path_path);
    BOOL result = [UIImagePNGRepresentation(img) writeToFile:path_path atomically:YES];
    NSLog(@"saveImage result:%d",result);
    
    //[_gmGridView reloadData];
}


+ (UIImage*) openThumbnailImg:(NSString*) filename {
    NSString *thumbnail_filename = [filename stringByAppendingString:@".thumb"];
    NSString *thumbnail_filepath = [[self getDocPath] stringByAppendingPathComponent:thumbnail_filename];
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    if ([file_mgr fileExistsAtPath:thumbnail_filepath]) {
        return [UIImage imageWithContentsOfFile:thumbnail_filepath];
    }
    return nil;
}

+ (UIImage*) openOrCreateThumbnailImg:(NSString*) filename imgSize:(CGSize) size {
    
    NSString *thumbnail_filename = [filename stringByAppendingString:@".thumb"];
    NSString *thumbnail_filepath = [[self getDocPath] stringByAppendingPathComponent:thumbnail_filename];
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    if ([file_mgr fileExistsAtPath:thumbnail_filepath]) {
        return [UIImage imageWithContentsOfFile:thumbnail_filepath];
    }
    
    NSString *filepath = [[self getDocPath] stringByAppendingPathComponent:filename];
    
    UIImage *thumbnail_img =
    [[UIImage imageWithContentsOfFile:filepath]
     resizedImageWithContentMode:UIViewContentModeScaleAspectFit
     bounds:size  interpolationQuality:kCGInterpolationHigh];
    [self saveImage: thumbnail_img fileNmae:thumbnail_filename];
    return thumbnail_img;
}

+ (UIImage*) openThumbnailImgFromIndex:(NSInteger) index
                           outFileName:(NSString**) filename {
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                       [self getDocPath]];
    
    int file_cnt = 0;
    //NSString *filepath;
    UIImage *thumbnail_img;
    
    //NSLog(@"cellForItemAtIndex index:%d",index);
    while (*filename= [dir_enum nextObject]) {
        
        if ([[*filename pathExtension] isEqualToString:@"png"] ||
            [[*filename pathExtension] isEqualToString:@"jpg"] ) {
            if (index==file_cnt) {
                thumbnail_img =
                [self openThumbnailImg:*filename];
                
                //NSLog(@"filename: %@", *filename);
                return thumbnail_img;
                break;
            }
            ++file_cnt;
        }
        
        
    }
    return nil;
}

+ (UIImage*) openOrCreateThumbnailImgFromIndex:(NSInteger) index
                                       ImgSize:(CGSize)size
                                   outFileName:(NSString**) filename {
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                       [self getDocPath]];
    
    int file_cnt = 0;
    //NSString *filepath;
    UIImage *thumbnail_img;
    
    //NSLog(@"cellForItemAtIndex index:%d",index);
    while (*filename= [dir_enum nextObject]) {
        
        if ([[*filename pathExtension] isEqualToString:@"png"] ||
            [[*filename pathExtension] isEqualToString:@"jpg"] ) {
            if (index==file_cnt) {
                thumbnail_img =
                [self openOrCreateThumbnailImg:*filename imgSize:size];
                
                //NSLog(@"filename: %@", *filename);
                return thumbnail_img;
                break;
            }
            ++file_cnt;
        }
        
        
    }
    return nil;
}

+(NSInteger) getFileCount {
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                       [self getDocPath]];
    
    int file_cnt = 0;
    NSString *filename;
    while (filename=[dir_enum nextObject]) {
        if ([[filename pathExtension] isEqualToString:@"png"] ||
            [[filename pathExtension] isEqualToString:@"jpg"] ) {
            file_cnt++;
        }
    }
    
    return file_cnt;
}


@end
