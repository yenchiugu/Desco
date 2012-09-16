//
//  StuffViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/14/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "StuffViewController.h"
#import "SkImageViewCell.h"

@interface StuffViewController ()

@end

@implementation StuffViewController

@synthesize gridView;

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

  //self.view.
  AQGridView *my_gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 3000, 100)];
  my_gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth;//|UIViewAutoresizingFlexibleHeight;
	my_gridView.autoresizesSubviews = NO;
	my_gridView.delegate = self;
	my_gridView.dataSource = self;
  my_gridView.backgroundColor = [UIColor redColor];
  my_gridView.opaque = NO;
  my_gridView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
  my_gridView.usesPagedHorizontalScrolling = YES;
  my_gridView.showsHorizontalScrollIndicator = YES;
  my_gridView.showsVerticalScrollIndicator = NO;
  [my_gridView setResizesCellWidthToFit:YES];
  //[my_gridView setContentSize:CGSizeMake(1700, -50)];
  my_gridView.backgroundViewExtendsRight=YES;
  my_gridView.backgroundViewExtendsLeft=YES;
  my_gridView.scrollEnabled=YES;
  
  

  self.gridView = my_gridView;
  
  _doc_img_path = [[NSBundle mainBundle]pathForResource:@"Document" ofType:@"png"];
  _demo_items=[[NSArray alloc] initWithObjects:@"notes.txt", nil ];
  
  [self.view addSubview:gridView];
  [self.gridView reloadData];
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

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
//  return ( [_imageNames count] );
  return 20;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
  static NSString * PlainCellIdentifier = @"PlainCellIdentifier";
  
  AQGridViewCell * cell = nil;
  

  SkImageViewCell * plainCell = (SkImageViewCell *)[aGridView dequeueReusableCellWithIdentifier: PlainCellIdentifier];
  if ( plainCell == nil )
  {
    plainCell = [[SkImageViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 90, 90)
                                             reuseIdentifier: PlainCellIdentifier];
    plainCell.selectionGlowColor = [UIColor colorWithRed:0 green:0 blue:66 alpha:20];
  }
  
  plainCell.image = [UIImage imageWithContentsOfFile:_doc_img_path];
  
  
  cell = plainCell;
  
  return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
  return ( CGSizeMake(100, 100) );
}

#pragma mark -

@end
