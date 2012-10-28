//
//  SKFriendProfileUtils.m
//  PullTest
//
//  Created by Sam Ku on 12/10/28.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "SKFriendProfileUtils.h"

@implementation SKFriendProfileUtils

+(NSString*) getDocPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+(NSString*) getFriendPath {
    return [[self getDocPath] stringByAppendingPathComponent:@"friends"];
}

+(NSInteger) getProfileCount {
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                       [self getFriendPath]];
    
    int file_cnt = 0;
    NSString *filename;
    while (filename=[dir_enum nextObject]) {
        if ([[filename pathExtension] isEqualToString:@"profile"]) {
            file_cnt++;
        }
    }
    
    return file_cnt;
}

+ (UIImage*) openProfileImg:(NSString*) filename {
    NSString *thumbnail_filename = [filename stringByAppendingString:@".thumb"];
    NSString *thumbnail_filepath = [[self getDocPath] stringByAppendingPathComponent:thumbnail_filename];
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    if ([file_mgr fileExistsAtPath:thumbnail_filepath]) {
        return [UIImage imageWithContentsOfFile:thumbnail_filepath];
    }
    return nil;
}

+ (UIImage*) openProfileImgFromIndex:(NSInteger) index
                           outFileName:(NSString**) filename {
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                       [self getFriendPath]];
    
    int file_cnt = 0;
    //NSString *filepath;
    UIImage *profile_img;
    
    //NSLog(@"cellForItemAtIndex index:%d",index);
    while (*filename= [dir_enum nextObject]) {
        
        if ([[*filename pathExtension] isEqualToString:@"profile"]) {
            if (index==file_cnt) {
                NSString *profile_filepath = [[self getFriendPath]
                                                stringByAppendingPathComponent:*filename];
                profile_img =
                    [UIImage imageWithContentsOfFile:profile_filepath];
                
                //NSLog(@"filename: %@", *filename);
                return profile_img;

            }
            ++file_cnt;
        }
        
        
    }
    return nil;
}

@end