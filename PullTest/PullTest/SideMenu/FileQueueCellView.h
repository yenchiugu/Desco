//
//  FileQueueCellView.h
//  PullTest
//
//  Created by Ace Wu on 12/10/27.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileQueueCellView : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *fileIconView;
@property (strong, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIImageView *friendAvatarView;
@property (strong, nonatomic) IBOutlet UILabel *directionLebel;

@end


@interface FileProgress : NSObject

@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *fileIconPath;
@property (strong, nonatomic) NSString *friendName;
@property float progress;
@property BOOL isDownload;

@end
