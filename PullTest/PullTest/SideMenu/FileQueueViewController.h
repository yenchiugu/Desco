//
//  FileQueueViewController.h
//  PullTest
//
//  Created by Ace Wu on 12/9/16.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileQueueCellView.h"
#import "../DropboxManager/DropboxManager.h"

@interface FileQueueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DropboxManagerDelegate>

@property (weak, nonatomic) SKViewController* mainViewController;
@property (strong, nonatomic) IBOutlet UITableView *fileQueueTable;
@property (strong, nonatomic) NSMutableDictionary *files;
@property (strong, nonatomic) NSMutableDictionary *downloadedFiles;

- (NSInteger)indexOfFile:(NSString *)fileId;
- (BOOL)createTransferProgressForFileId:(NSString *)fileId
                               fullPath:(NSString *)fullPath
                               userName:(NSString *)userName
                             isDownload:(BOOL)isDownload;
@end
