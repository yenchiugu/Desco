//
//  FileQueueViewController.h
//  PullTest
//
//  Created by Ace Wu on 12/9/16.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileQueueViewController : UIViewController
{
  UITableView *fileQueueTable;
}
@property (strong, nonatomic) IBOutlet UITableView *fileQueueTable;

@end
