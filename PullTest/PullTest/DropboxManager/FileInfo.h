//
//  FileInfo.h
//  PullTest
//
//  Created by Ace Wu on 12/10/24.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInfo : NSObject
{
    NSString *fileName;
    NSString *fromUser;
    NSString *toUser;
    long long totalSize;
    long long processedSize;
    double timestamp;
    float progress;
}
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *fromUser;
@property (strong, nonatomic) NSString *toUser;
@property long long totalSize;
@property long long processdSize;
@property double timestamp;
@property float progress;

- (FileInfo *) initWithPath:(NSString *)path;
- (FileInfo *) initWithPath:(NSString *)path inProgress:(CGFloat)currentProgress;
@end
