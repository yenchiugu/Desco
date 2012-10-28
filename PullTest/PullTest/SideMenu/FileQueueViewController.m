//
//  FileQueueViewController.m
//  PullTest
//
//  Created by Ace Wu on 12/9/16.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "FileQueueViewController.h"
#import "../SKFriendProfileUtils.h"
#import "../SKViewController.h"

@interface FileQueueViewController ()

@end

@implementation FileQueueViewController

@synthesize mainViewController;
@synthesize fileQueueTable;
@synthesize files;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        files = [NSMutableDictionary dictionary];
        /*
         // dummy queue
        FileProgress *newFile;
        newFile = [[FileProgress alloc] init];
        newFile.fileName = @"test.jpg";
        newFile.friendName = @"Smiler";
        newFile.progress = 23.43f;
        newFile.isDownload = YES;
        [files setObject:newFile forKey:@"test1"];
        newFile = [[FileProgress alloc] init];
        newFile.fileName = @"haha.mp3";
        newFile.friendName = @"Sam";
        newFile.progress = 98.10f;
        newFile.isDownload = NO;
        [files setObject:newFile forKey:@"test2"];
         */
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSBundle mainBundle] loadNibNamed:@"FileQueueTableView" owner:self options:nil];
    NSLog(@"%@", fileQueueTable);
    fileQueueTable.rowHeight = 110;
    self.view = fileQueueTable;
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"FileQ_content_2_act9.png"]];
}

- (void)viewDidUnload
{
    [self setFileQueueTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)createTransferProgressForFileId:(NSString *)fileId
                               fullPath:(NSString *)fullPath
                               userName:(NSString *)userName
                             isDownload:(BOOL)isDownload
{
    if ([files objectForKey:fileId]) {
        return NO;
    }
    FileProgress *newFile = [[FileProgress alloc] init];
    newFile.fileName = [fullPath lastPathComponent];
    newFile.friendName = userName;
    newFile.progress = 0.0f;
    newFile.isDownload = isDownload;
    newFile.fileIconPath = [fullPath stringByAppendingString:@".thumb"];
    [files setObject:newFile forKey:fileId];
    [fileQueueTable reloadData];
    return YES;
}

#pragma mark - callbacks for DropboxManager
- (void)uploadProgress:(CGFloat)progress
               forFile:(NSString *)fileName
                toUser:(NSString *)toUser
              uploaded:(long long)uploadedSize
                 total:(long long)totalSize
                fileId:(NSString *)fileId
{
    FileProgress *file = [files objectForKey:fileId];
    if (!file) {
        NSLog(@"!!! can not find the file:%@", fileName);
        return;
    }
    file.progress = progress;
    [fileQueueTable reloadData];
}

- (void)uploadedFile:(NSString *)fileName
              toUser:(NSString *)toUser
              fileId:(NSString *)fileId
{
    [files removeObjectForKey:fileId];
    [fileQueueTable reloadData];
}

- (void)uploadFileFailedWithError:(NSError *)error
{}

- (void)downloadStartForFile:(NSString *)fileName
                      toPath:(NSString *)localFile
                    fromUser:(NSString *)fromUser
                      fileId:(NSString *)fileId
{
    NSLog(@"create download:%@", fileId);
    [self createTransferProgressForFileId:fileId fullPath:localFile userName:fromUser isDownload:YES];
}

- (void)downloadProgress:(CGFloat)progress
                 forFile:(NSString *)fileName
                fromUser:(NSString *)user
              downloaded:(long long)downloadedSize
                   total:(long long)totalSize
                  fileId:(NSString *)fileId
{
    FileProgress *file = [files objectForKey:fileId];
    NSLog(@"download progress id:%@", fileId);
    if (!file) {
        NSLog(@"!!! can not find the file:%@", fileId);
        return;
    }
    file.progress = progress;
    [fileQueueTable reloadData];
}

- (void)downloadedFile:(NSString *)fileName
              fromUser:(NSString *)fromUser
                fileId:(NSString *)fileId
{
    [files removeObjectForKey:fileId];
    [fileQueueTable reloadData];    
    [mainViewController.my_stuff_view_controllor reloadData];
}

- (void)downloadFileFailedWithError:(NSError *)error
{}

#pragma mark - callbacks for UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uniqueId = @"fileQueueCellView";
    FileQueueCellView *cell = (FileQueueCellView *)[fileQueueTable dequeueReusableCellWithIdentifier:uniqueId];
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FileQueueCellView" owner:nil options:nil];
        for (id obj in topLevelObjects) {
            if ([obj isKindOfClass:[FileQueueCellView class]]) {
                cell = (FileQueueCellView *)obj;
                break;
            }
        }
    }

    FileProgress *file = [files objectForKey:[files.allKeys objectAtIndex:indexPath.row]];
    cell.friendAvatarView.image = [SKFriendProfileUtils openProfileImgByName:file.friendName];
    cell.fileIconView.image  = [UIImage imageWithContentsOfFile:file.fileIconPath];
    cell.fileNameLabel.text  = file.fileName;
    cell.progressView.progress  = file.progress/100;
    cell.progressLabel.text  = [NSString stringWithFormat:@"%0.2f",file.progress];
    cell.directionLebel.text = (file.isDownload) ? @"From" : @"To";
    
    return cell;
}

@end
