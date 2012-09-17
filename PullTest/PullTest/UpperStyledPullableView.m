//
//  UpperStyledPullableView.m
//  PullTest
//
//  Created by Sam Ku on 9/15/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UpperStyledPullableView.h"

#import "GMGridViewLayoutStrategies.h"
@implementation UpperStyledPullableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mybarbarupbk.png"]];
      imgView.frame = CGRectMake(0, 0, frame.size.width, 200);
      [self addSubview:imgView];
      
      _user_img_path01 = [[NSBundle mainBundle]pathForResource:@"user01" ofType:@"jpg"];
      _user_img_path02 = [[NSBundle mainBundle]pathForResource:@"user02" ofType:@"jpg"];
      _user_img_path03 = [[NSBundle mainBundle]pathForResource:@"user03" ofType:@"jpg"];
      _user_img_path04 = [[NSBundle mainBundle]pathForResource:@"user04" ofType:@"jpg"];
      _user_img_path05 = [[NSBundle mainBundle]pathForResource:@"user05" ofType:@"jpg"];
      _user_img_path06 = [[NSBundle mainBundle]pathForResource:@"user06" ofType:@"jpg"];
      _user_img_path07 = [[NSBundle mainBundle]pathForResource:@"user07" ofType:@"jpg"];
      _user_img_path08 = [[NSBundle mainBundle]pathForResource:@"user08" ofType:@"jpg"];
      _user_img_path09 = [[NSBundle mainBundle]pathForResource:@"user09" ofType:@"jpg"];
      _user_img_path10 = [[NSBundle mainBundle]pathForResource:@"user10" ofType:@"jpg"];
      
      GMGridView *gmGridView2 = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 160)];
      gmGridView2.autoresizingMask = UIViewAutoresizingFlexibleWidth;// | UIViewAutoresizingFlexibleHeight;
      gmGridView2.style = GMGridViewStylePush;
      gmGridView2.itemSpacing = 5;
      gmGridView2.minEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
      gmGridView2.centerGrid = YES;
      gmGridView2.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
      [self addSubview:gmGridView2];
      _gmGridView = gmGridView2;
      
      [self computeViewFrames];
      
      //_gmGridView.sortingDelegate = self;
      //_gmGridView.transformDelegate = self;
      _gmGridView.dataSource = self;
      
      _gmGridView.mainSuperView = self;
    }
  
  _animatedCell = NULL;
    return self;
}
//////////////////////////////////////////////////////////////
#pragma mark Privates
//////////////////////////////////////////////////////////////

- (void)computeViewFrames
{
  
  
  
  CGRect frame2 = CGRectMake(0, 0, self.bounds.size.width ,180);
  
  
  _gmGridView.frame = frame2;
  
  
  
  
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
  return 10;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
  if (INTERFACE_IS_PHONE)
  {
    return CGSizeMake(140, 110);
  }
  else
  {
    return CGSizeMake(160, 160);
  }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
  CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
  
//  GMGridViewCell *cell = [gridView dequeueReusableCell];
    GMGridViewCell *cell = NULL;
//  if (!cell)
//  {
    cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height+20)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    NSString *tmp_img_path;
    if (index==0) {
      tmp_img_path = _user_img_path01;
    }
    else if (index==1) {
      tmp_img_path = _user_img_path02;
    }
    else if (index==2) {
      tmp_img_path = _user_img_path03;
    }
    else if (index==3) {
      tmp_img_path = _user_img_path04;
    }
    else if (index==4) {
      tmp_img_path = _user_img_path05;
    }
    else if (index==5) {
      tmp_img_path = _user_img_path06;
    }
    else if (index==6) {
      tmp_img_path = _user_img_path07;
    }
    else if (index==7) {
      tmp_img_path = _user_img_path08;
    }
    else if (index==8) {
      tmp_img_path = _user_img_path09;
    }
    else if (index==9) {
      tmp_img_path = _user_img_path10;
    }
    imageView.image = [UIImage imageWithContentsOfFile:tmp_img_path];
    
    [view addSubview:imageView];
    //view.backgroundColor =[UIColor greenColor];
    //view.layer.masksToBounds = NO;
    //view.layer.cornerRadius = 8;
    //view.layer.shadowColor = [UIColor grayColor].CGColor;
    //view.layer.shadowOffset = CGSizeMake(5, 5);
    //view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    //view.layer.shadowRadius = 8;
    
    cell.contentView = view;
 // }
  
  //[[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,size.height,size.width,20)];//cell.contentView.bounds];
    //label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //label.text = @"test";
    //label.textAlignment = UITextAlignmentCenter;
    //label.backgroundColor = [UIColor clearColor];
    //label.textColor = [UIColor blackColor];
    //label.font = [UIFont boldSystemFontOfSize:20];
    //[cell.contentView addSubview:label];
  
  return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)draggingEvent:(CGPoint) pt sourceView:(UIView *)srcView {
  CGPoint converted_p =[srcView convertPoint:pt toView:_gmGridView];
  NSLog(@"converted: [%f,%f]",converted_p.x,converted_p.y);
  UIView *target=[_gmGridView hitTest:converted_p withEvent:nil];
  int position = [_gmGridView.layoutStrategy itemPositionFromLocation:converted_p];
  
  NSLog(@"positoin:%d",position);
  NSLog(@"target:%@",target);

  if (position!=-1) {
    //CGPoint converted_p2 =[self convertPoint:converted_p toView:target];

    //UIView *target2=[target hitTest:converted_p2 withEvent:nil];
    //NSLog(@"target2:%@",target2);
    //int position = [_gmGridView.layoutStrategy itemPositionFromLocation:converted_p];
    GMGridViewCell *cell = [_gmGridView cellForItemAtIndex:position];
    if (_animatedCell) {
      [UIView animateWithDuration:0 delay:0
                          options:UIViewAnimationOptionBeginFromCurrentState
                       animations:(void (^)(void)) ^ {
                         _animatedCell.transform=CGAffineTransformIdentity;}
                       completion:nil
       //^(BOOL finished) {
       //  cell.transform=CGAffineTransformIdentity;
       // }
       ];
      _animatedCell=NULL;
    }
    if (cell) {
      [UIView animateWithDuration:0 delay:0
                          options:UIViewAnimationOptionBeginFromCurrentState
                       animations:(void (^)(void)) ^ {
                         cell.transform=CGAffineTransformMakeScale(1.1, 1.1);}
                       completion:nil
                       //^(BOOL finished) {
                       //  cell.transform=CGAffineTransformIdentity;
                      // }
       ];
      [_gmGridView bringSubviewToFront:cell];
      _animatedCell = cell;
    }

      }
  
}
- (void)droppedEvent:(CGPoint) pt sourceView:(UIView *)srcView {
  
}

@end
