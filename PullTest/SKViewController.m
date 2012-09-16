//
//  SKViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/9/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "SKViewController.h"
#import "NGTabBarController/NGTabBarController.h"
#import "StuffViewController.h"
@interface SKViewController ()

@end

@implementation SKViewController

@synthesize bottomView;
@synthesize tabBarController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  float my_width=self.view.bounds.size.width;
  PullableView * pullable_vew = [[PullableView alloc]
                                 initWithFrame:CGRectMake(
                                                          0, 0, my_width,500)];
                                   //self.view.frame.size.width,
                                   //self.view.frame.size.height/7 )];
  pullable_vew.openedCenter = CGPointMake(my_width/2, self.view.frame.size.height+50);
  pullable_vew.closedCenter = CGPointMake(my_width/2, self.view.frame.size.height+230);
  pullable_vew.center = pullable_vew.closedCenter;
  pullable_vew.handleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
  pullable_vew.handleView.backgroundColor = [UIColor whiteColor];
  pullable_vew.backgroundColor = [UIColor whiteColor];
  pullable_vew.delegate = self;
  
  bottomView = pullable_vew;
  [self.view addSubview:pullable_vew];
  
  UILabel *pullUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(my_width/2-50, 4, 100, 20)];
  pullUpLabel.textAlignment = UITextAlignmentCenter;
  pullUpLabel.backgroundColor = [UIColor clearColor];
  pullUpLabel.textColor = [UIColor blackColor];
  pullUpLabel.text = @"Pull me up!";
  
  [pullable_vew addSubview:pullUpLabel];
  
  StuffViewController *my_stuff_view_controllor = [[StuffViewController alloc] initWithNibName:nil bundle:nil];
  UIViewController *recent_view_controllor = [[UIViewController alloc] initWithNibName:nil bundle:nil];

  //[[my_stuff_view_controllor view] setBackgroundColor:[UIColor clearColor]];
  
  my_stuff_view_controllor.ng_tabBarItem =
    [NGTabBarItem itemWithTitle:@"My Stuffs" image:[UIImage imageNamed:@"Comments"]];
  recent_view_controllor.ng_tabBarItem =
  [NGTabBarItem itemWithTitle:@"Recent" image:[UIImage imageNamed:@"Email"]];

  [my_stuff_view_controllor.ng_tabBarItem setTitleColor:[UIColor lightGrayColor]];
  
  
  NSArray *viewController = [NSArray arrayWithObjects:my_stuff_view_controllor,recent_view_controllor,nil];
  
  tabBarController = [[NGTabBarController alloc] initWithDelegate:self];
  tabBarController.tabBarPosition = NGTabBarPositionTop;
  tabBarController.tabBar.drawItemHighlight = NO;
  tabBarController.tabBar.drawGloss = NO;
  tabBarController.tabBar.layoutStrategy = NGTabBarLayoutStrategyStrungTogether;
  tabBarController.tabBar.tintColor=[UIColor whiteColor];
  tabBarController.tabBar.itemPadding=0.f;
  tabBarController.viewControllers = viewController;
  
  
  
  [pullable_vew addSubview:tabBarController.view];
  
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

- (void) pullableView:(PullableView *)pView didChangeState:(BOOL)opened
{
  
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NGTabBarControllerDelegate
////////////////////////////////////////////////////////////////////////

- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position {
  if (NGTabBarIsVertical(position)) {
    return CGSizeMake(200.f, 100.f);
  } else {
    return CGSizeMake(60.f, 65.f);
  }
}


@end
