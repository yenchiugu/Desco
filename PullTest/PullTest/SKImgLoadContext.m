//
//  SKImgLoadContext.m
//  PullTest
//
//  Created by Sam Ku on 12/10/27.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "SKImgLoadContext.h"

@implementation SKImgLoadContext

@synthesize index;

-(SKImgLoadContext*) initWithIndex:(NSInteger) idx {
    self = [super init];
    
    if (self) {
        [self setIndex:idx];
    }
    return self;
}

@end

