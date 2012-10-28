//
//  FileQueueViewController.h
//  PullTest
//
//  Created by Ace Wu on 12/9/16.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileQueueCellView.h"


@interface FileQueueViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *fileQueueTable;
@property (strong, nonatomic) NSMutableDictionary *files;
- (NSInteger)indexOfFile:(NSString *)fileId;
@end
