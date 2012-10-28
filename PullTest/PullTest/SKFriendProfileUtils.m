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

+(NSString*) getProfilePathByName:(NSString *)userName
{
    NSString *fileName = [NSString stringWithFormat:@"%@.png",userName];
    return [[self getFriendPath] stringByAppendingPathComponent:fileName];
}

+(NSInteger) getProfileCount {
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                       [self getFriendPath]];
    
    int file_cnt = 0;
    NSString *filename;
    while (filename=[dir_enum nextObject]) {
        if ([[filename pathExtension] isEqualToString:@"png"]) {
            file_cnt++;
        }
    }
    
    return file_cnt;
}


+ (UIImage *) openProfileImgByName:(NSString *)userName
{
    return [UIImage imageWithContentsOfFile:[self getProfilePathByName:userName]];
}

+ (UIImage *) openProfileImgFromIndex:(NSInteger) index
                           outFileName:(NSString**) filename {
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                       [self getFriendPath]];
    
    int file_cnt = 0;
    //NSString *filepath;
    UIImage *profile_img;
    
    //NSLog(@"cellForItemAtIndex index:%d",index);
    while (*filename= [dir_enum nextObject]) {
        
        if ([[*filename pathExtension] isEqualToString:@"png"]) {
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
