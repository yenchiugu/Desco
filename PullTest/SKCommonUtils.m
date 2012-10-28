//
//  SKCommonUtils.m
//  PullTest
//
//  Created by Sam Ku on 12/10/28.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "SKCommonUtils.h"

@implementation SKCommonUtils
+(NSString*) getDocPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
@end
