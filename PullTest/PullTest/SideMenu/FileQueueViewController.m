//
//  FileQueueViewController.m
//  PullTest
//
//  Created by Ace Wu on 12/9/16.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "FileQueueViewController.h"

@interface FileQueueViewController ()

@end

@implementation FileQueueViewController

@synthesize fileQueueTable;
@synthesize files;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        files = [NSMutableArray array];
        FileProgress *newFile;
        newFile = [[FileProgress alloc] init];
        newFile.fileName = @"test.jpg";
        newFile.friendName = @"Ace Wu";
        newFile.prograss = 23.43f;
        [files addObject:newFile];
        newFile = [[FileProgress alloc] init];
        newFile.fileName = @"haha.mp3";
        newFile.friendName = @"Sam Ku";
        newFile.prograss = 98.10f;
        [files addObject:newFile];
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

#pragma mark - callbacks for UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uniqueId = @"fileQueueCellView";
    FileQueueCellView *cell = (FileQueueCellView *)[fileQueueTable dequeueReusableCellWithIdentifier:uniqueId];
    FileProgress *file = [files objectAtIndex:[indexPath row]];
    
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FileQueueCellView" owner:nil options:nil];
        for (id obj in topLevelObjects) {
            if ([obj isKindOfClass:[FileQueueCellView class]]) {
                cell = (FileQueueCellView *)obj;
                break;
            }
        }
    }
    
    //cell.fileIconView
    cell.fileNameLabel.text = file.fileName;
    cell.progressView.progress = file.prograss/100;
    cell.progressLabel.text = [NSString stringWithFormat:@"%0.2f",file.prograss];
    
    return cell;
}

@end
