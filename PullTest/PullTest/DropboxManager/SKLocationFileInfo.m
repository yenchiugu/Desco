//
//  SKLocationFileInfo.m
//  PullTest
//
//  Created by Sam Ku on 12/10/28.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "SKLocationFileInfo.h"
#import "SKCommonUtils.h"

@implementation SKLocationFileInfo
{
    NSRegularExpression *regex;
}
@synthesize filename;
@synthesize username;
@synthesize latitude;
@synthesize longitude;
@synthesize keepHours;
@synthesize fullpath;

- (SKLocationFileInfo *) initWithPath:(NSString *)path {
    if (self = [super init]) {
        NSError *error = nil;
        regex = [NSRegularExpression regularExpressionWithPattern:@"^([^+]+)\\+([^+]+)\\+([^+]+)\\+([^+]+)\\+(.+)$" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSTextCheckingResult *match = [regex firstMatchInString:path options:0 range:NSMakeRange(0, [path length])];
        if (NSEqualRanges(NSMakeRange(NSNotFound, 0), [match rangeAtIndex:0])) {
            return nil;
        } else {

            filename  = [path substringWithRange:[match rangeAtIndex:5]];
            fullpath  = path;
            username  = [path substringWithRange:[match rangeAtIndex:4]];
            latitude    = [[path substringWithRange:[match rangeAtIndex:1] ] doubleValue];
            longitude   = [[path substringWithRange:[match rangeAtIndex:2]] doubleValue];
            keepHours = [[path substringWithRange:[match rangeAtIndex:3]] intValue];
        }
    }
    return self;
}

+ (NSString *)encodeLocationFileName:(NSString *)fileName latitude:(double)_latitude
                           longitude:(double) _longitue keepHours:(int) _keepHours userName:(NSString *) username
{
    
    return [NSString stringWithFormat:@"%f+%f+%d+%@+%@",
                          _latitude,
                          _longitue,
                          _keepHours,
                          username,
                          fileName
                          ];

}



+ (NSString *)getLocalLocationSharePath {
    return [[SKCommonUtils getDocPath] stringByAppendingPathComponent:@"location_share"];
}

+ (BOOL)isLocationShareFolder:(NSString *)path
{
    
    NSRange range = [path rangeOfString:@"/location_share"];
    if (range.location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

@end
