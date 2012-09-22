//
//  SKStuffViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/15/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SKStuffViewController.h"
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"
#import "UpperStyledPullableView.h"

@interface SKStuffViewController () <GMGridViewDataSource,GMGridViewSortingDelegate,GMGridViewTransformationDelegate> {
  __gm_weak GMGridView *_gmGridView;
}

//- (void)computeViewFrames;
@end

@implementation SKStuffViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
  [super loadView];
 
  _doc_img_path = [[NSBundle mainBundle]pathForResource:@"Word" ofType:@"png"];
  _pdf_img_path = [[NSBundle mainBundle]pathForResource:@"Reader" ofType:@"png"];
  _jpg_img_path = [[NSBundle mainBundle]pathForResource:@"Jpg" ofType:@"png"];
  _mkv_img_path = [[NSBundle mainBundle]pathForResource:@"MKV" ofType:@"png"];
  _mpg_img_path = [[NSBundle mainBundle]pathForResource:@"MPG" ofType:@"png"];

  
  GMGridView *gmGridView2 = [[GMGridView alloc] initWithFrame:self.view.bounds];
  gmGridView2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  gmGridView2.style = GMGridViewStylePush;
  gmGridView2.itemSpacing = 5;
  gmGridView2.minEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
  gmGridView2.centerGrid = YES;
  gmGridView2.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
  [self.view addSubview:gmGridView2];
  _gmGridView = gmGridView2;
  
  [self computeViewFrames];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  _gmGridView.sortingDelegate = self;
  _gmGridView.transformDelegate = self;
  _gmGridView.dataSource = self;
  
  UIView *view1 = self.parentViewController.view;
  UIView *view2 = self.parentViewController.parentViewController.view;
  UIView *view3 = self.parentViewController.parentViewController.parentViewController.view;
  
  UIView *upper_view = [view2 viewWithTag:2377 ];
  if (upper_view) {
    [_gmGridView setSkDragDelegate:(UpperStyledPullableView*)upper_view];
  }
//  UIView *view4 = self.view.superview.superview.superview.superview;

  _gmGridView.mainSuperView =view2;
}

- (void)viewDidLayoutSubviews
{
  [self computeViewFrames];
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
//////////////////////////////////////////////////////////////
#pragma mark Privates
//////////////////////////////////////////////////////////////

- (void)computeViewFrames
{

  

  CGRect frame2 = CGRectMake(0, 0, self.view.bounds.size.width ,100);
  

  _gmGridView.frame = frame2;

  
 
  
}
//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
  return 11;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
  if (INTERFACE_IS_PHONE)
  {
    return CGSizeMake(140, 110);
  }
  else
  {
    return CGSizeMake(90, 90);
  }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
  CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
  
  GMGridViewCell *cell = nil;//[gridView dequeueReusableCell];
  
  if (!cell)
  {
    cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height+20)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    if (index==0||index==1 ||index==5) {
      imageView.image = [UIImage imageWithContentsOfFile:_jpg_img_path];
      
    } else if (index==2) {
      imageView.image = [UIImage imageWithContentsOfFile:_doc_img_path];

    } else if (index==3 || index==4) {
      imageView.image = [UIImage imageWithContentsOfFile:_pdf_img_path];

    } else if (index==6) {
      imageView.image = [UIImage imageWithContentsOfFile:_mkv_img_path];

    } else if (index==7) {
      imageView.image = [UIImage imageWithContentsOfFile:_mpg_img_path];

    } else{
      imageView.image = [UIImage imageWithContentsOfFile:_jpg_img_path];

    }
        
    [view addSubview:imageView];
    //view.backgroundColor =[UIColor greenColor];
    //view.layer.masksToBounds = NO;
    //view.layer.cornerRadius = 8;
    //view.layer.shadowColor = [UIColor grayColor].CGColor;
    //view.layer.shadowOffset = CGSizeMake(5, 5);
    //view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    //view.layer.shadowRadius = 8;
    
    cell.contentView = view;
  }
  
  //[[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,size.height,size.width,25)];//cell.contentView.bounds];
  //label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  NSString *str=@"";
  if (index==0) {
    str=@"民宿1_8044195d";
  } else if(index==1) {
    str=@"民宿2_3718011414_2e85c9efc3_o";
  } else if (index==2) {
    str=@"201109墾丁行程";
  } else if (index==3) {
    str=@"xUnit_Test_Patterns_Refactoring_Test_Code";
  } else if (index==4) {
    str=@"pcav";
  } else if (index==5) {
    str=@"QR share 12-9-10 12 33 53.jpg";
  } else if (index==6) {
    str=@"20111222";
  } else if (index==7) {
    str=@"20110310013";
  } else if (index==8){
    str=@"Smiler的秘密";
  } else if (index==9){
    str=@"Ace的生活";
  } else if (index==10){
    str=@"SamKu的一天";
  }
  label.text = str;
  label.textAlignment = UITextAlignmentCenter;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor blackColor];
  label.font = [UIFont boldSystemFontOfSize:16];
  [cell.contentView addSubview:label];
  
  return cell;
}

//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
  CGSize viewSize = self.view.bounds.size;
  return CGSizeMake(viewSize.width - 50, viewSize.height - 50);
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
  UIView *fullView = [[UIView alloc] init];
  fullView.backgroundColor = [UIColor yellowColor];
  fullView.layer.masksToBounds = NO;
  fullView.layer.cornerRadius = 8;
  
  CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
  fullView.bounds = CGRectMake(0, 0, size.width, size.height);
  
  UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
  label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
  label.textAlignment = UITextAlignmentCenter;
  label.backgroundColor = [UIColor clearColor];
  label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  if (INTERFACE_IS_PHONE)
  {
    label.font = [UIFont boldSystemFontOfSize:15];
  }
  else
  {
    label.font = [UIFont boldSystemFontOfSize:20];
  }
  
  [fullView addSubview:label];
  
  
  return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
  [UIView animateWithDuration:0.5
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction
                   animations:^{
                     cell.contentView.backgroundColor = [UIColor blueColor];
                     cell.contentView.layer.shadowOpacity = 0.7;
                   }
                   completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
  [UIView animateWithDuration:0.5
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction
                   animations:^{
                     cell.contentView.backgroundColor =  [UIColor greenColor];
                     cell.contentView.layer.shadowOpacity = 0;
                   }
                   completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(GMGridViewCell *)cell
{
  
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
  [UIView animateWithDuration:0.3
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction
                   animations:^{
                     cell.contentView.backgroundColor = [UIColor orangeColor];
                     cell.contentView.layer.shadowOpacity = 0.7;
                   }
                   completion:nil
   ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
  [UIView animateWithDuration:0.3
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction
                   animations:^{
                     cell.contentView.backgroundColor =  [UIColor clearColor];
                     cell.contentView.layer.shadowOpacity = 0;
                   }
                   completion:nil
   ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
  return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
  // We dont care about this in this demo (see demo 1 for examples)
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
  // We dont care about this in this demo (see demo 1 for examples)
}


@end
