//
//  DropboxManager.m
//  PullTest
//
//  Created by Ace Wu on 12/10/21.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "DropboxManager.h"

@implementation DropboxManager


- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata
{
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
    NSLog(@"File upload failed with error - %@", error);
}

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath
{
    NSLog(@"from:%@, to:%@, progress:%.2f", srcPath, destPath, progress); //Correct way to visualice the float
}

@end
