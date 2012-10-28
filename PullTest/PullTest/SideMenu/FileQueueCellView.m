//
//  FileQueueCellView.m
//  PullTest
//
//  Created by Ace Wu on 12/10/27.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "FileQueueCellView.h"

@implementation FileQueueCellView
@synthesize fileIconView;
@synthesize fileNameLabel;
@synthesize progressLabel;
@synthesize progressView;
@synthesize friendAvatarView;
@synthesize directionLebel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation FileProgress

@synthesize fileName;
@synthesize fileIconPath;
@synthesize friendName;
@synthesize progress;
@synthesize isDownload;

@end