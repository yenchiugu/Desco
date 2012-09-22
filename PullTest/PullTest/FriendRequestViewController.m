//
//  FriendRequestViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/22/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "FriendRequestViewController.h"

@interface FriendRequestViewController ()

@end

@implementation FriendRequestViewController
@synthesize imgView;
@synthesize friendLable;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setImgView:nil];
  [self setFriendLable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)ClickAcceptBtn:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(ClickAcceptBtn:)]) {
    [self.delegate ClickAcceptBtn:self];
  }
}
@end
