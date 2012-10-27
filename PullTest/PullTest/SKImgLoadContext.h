//
//  SKImgLoadContext.h
//  PullTest
//
//  Created by Sam Ku on 12/10/27.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKImgLoadContext : NSObject {
    NSInteger index;
}
@property (nonatomic) NSInteger index;
-(SKImgLoadContext*) initWithIndex:(NSInteger) index;

@end
