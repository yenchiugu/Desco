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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSBundle mainBundle] loadNibNamed:@"FileQueueTableView" owner:self options:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

@end
