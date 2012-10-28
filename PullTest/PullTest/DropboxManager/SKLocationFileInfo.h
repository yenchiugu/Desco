//
//  SKLocationFileInfo.h
//  PullTest
//
//  Created by Sam Ku on 12/10/28.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKLocationFileInfo : NSObject {
    NSString *filename;
    NSString *username;
    NSString *fullpath;
    double latitude;
    double longitude;
    int    keepHours;
}

@property (atomic, strong) NSString *filename;
@property (atomic, strong) NSString *username;
@property (atomic, strong) NSString *fullpath;
@property (atomic) double latitude;
@property (atomic) double longitude;
@property (atomic) int keepHours;

- (SKLocationFileInfo *) initWithPath:(NSString *)path;
+ (NSString *)encodeLocationFileName:(NSString *)fileName latitude:(double)_latitude
                           longitude:(double) _longitue keepHours:(int) _keepHours userName:(NSString *) username;
+ (NSString *)getLocalLocationSharePath;
+ (BOOL)isLocationShareFolder:(NSString *)path;
@end
