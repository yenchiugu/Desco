//
//  FileInfo.m
//  PullTest
//
//  Created by Ace Wu on 12/10/24.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "FileInfo.h"

@implementation FileInfo
{
    NSRegularExpression *regex;
}
@synthesize fileName;
@synthesize fromUser;
@synthesize toUser;
@synthesize totalSize;
@synthesize processdSize;
@synthesize progress;
@synthesize timestamp;

- (FileInfo *) initWithPath:(NSString *)path
{
    if (self = [super init]) {
        NSError *error = nil;
        regex = [NSRegularExpression regularExpressionWithPattern:@"^/user/([^/]+)/incoming/([^+]+)\\+([^+]+)\\+([^+]+)\\+(.+)$" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSTextCheckingResult *match = [regex firstMatchInString:path options:0 range:NSMakeRange(0, [path length])];
        if (NSEqualRanges(NSMakeRange(NSNotFound, 0), [match rangeAtIndex:0])) {
            return nil;
        } else {
            for (int i = 0; i < [match numberOfRanges]; ++i) {
                NSLog(@"%@", [path substringWithRange:[match rangeAtIndex:i]]);
            }
            //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            //[formatter setNumberStyle:NSNumberFormatter];
            fromUser  = [path substringWithRange:[match rangeAtIndex:3]];
            toUser    = [path substringWithRange:[match rangeAtIndex:1]];
            fileName  = [path substringWithRange:[match rangeAtIndex:5]];
            totalSize = [[path substringWithRange:[match rangeAtIndex:4]] longLongValue];
            timestamp = [[path substringWithRange:[match rangeAtIndex:2]] doubleValue];
            progress  = 0.0f;
            processdSize = 0;
        }
    }
    return self;
}

- (FileInfo *) initWithPath:(NSString *)path inProgress:(CGFloat)currentProgress;
{
    if (self = [self initWithPath:path]) {
        progress = currentProgress * 100;
        processdSize = [[NSNumber numberWithDouble:totalSize * currentProgress] longLongValue];
    }
    return self;
}
@end
