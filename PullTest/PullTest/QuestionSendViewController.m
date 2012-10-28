//
//  QuestionSendViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/20/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "QuestionSendViewController.h"

@interface QuestionSendViewController ()
@end


@implementation QuestionSendViewController

@synthesize delegate;
@synthesize srcFile;
@synthesize toUser;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)ClickYesBtn:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickSendYesBtn:)]) {
        [self.delegate ClickSendYesBtn:self];
    }
}

- (IBAction)ClickNoBtn:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickSendNoBtn:)]) {
        [self.delegate ClickSendNoBtn:self];
    }
}

- (void)clear
{
    srcFile = nil;
    toUser  = nil;
}
@end
