//
//  DropboxManager.m
//  PullTest
//
//  Created by Ace Wu on 12/10/21.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "DropboxManager.h"

@implementation DropboxManager

@synthesize userName;

- (DropboxManager *)initWithAppKey:(NSString *)key
                         appSecret:(NSString *)secret
                            myName:(NSString *)myName
                      downloadPath:(NSString *)path
{
    dbSession = [[DBSession alloc] initWithAppKey:key appSecret:secret root:kDBRootDropbox];
    [DBSession setSharedSession:dbSession];
    userName = myName;
    downloadPath = path;
    return self;
}

- (void)linkFromController:(UIViewController *)mainController
{
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:mainController];
    }
}

- (BOOL)isLinked
{
    return [[DBSession sharedSession] isLinked];
}

- (void)uploadFile:(NSString *)srcPath toUser:(NSString *)user;
{
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        [restClient setDelegate:self];
    }
    NSString *destPath = [NSString stringWithFormat:@"/user/%@/incoming/",user];
    [restClient uploadFile:[srcPath lastPathComponent] toPath:destPath withParentRev:nil fromPath:srcPath];
}

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
