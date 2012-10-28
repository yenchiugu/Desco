//
//  SKFriendProfileUtils.h
//  PullTest
//
//  Created by Sam Ku on 12/10/28.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKFriendProfileUtils : NSObject

+(NSInteger) getProfileCount ;
+ (UIImage*) openProfileImgFromIndex:(NSInteger) index
                         outFileName:(NSString**) filename;
@end
