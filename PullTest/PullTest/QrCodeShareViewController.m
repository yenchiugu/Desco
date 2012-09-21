//
//  QrCodeShareViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/21/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "QrCodeShareViewController.h"
#import "QRCodeGenerator.h"

@interface QrCodeShareViewController ()

@end

@implementation QrCodeShareViewController
@synthesize imgView;
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
  imgView.image = [QRCodeGenerator qrImageForString:@"https://www.dropbox.com/s/c29axuhi7xram60/pcav.pdf" imageSize:imgView.bounds.size.width];
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

- (IBAction)ClickDesktopDescoBtn:(id)sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(ClickDesktopDescoBtn:)]) {
    [self.delegate ClickDesktopDescoBtn:self];
  }
}
@end
