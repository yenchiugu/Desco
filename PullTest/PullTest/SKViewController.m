//
//  SKViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/9/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "SKViewController.h"
#import "NGTabBarController/NGTabBarController.h"
#import "SKStuffViewController.h"
#import "SKUserListViewController.h"
#import "StyledPullableView.h"
#import "UpperStyledPullableView.h"

#import "TouchTracker/TouchTracker.h"
#import "SideMenu/FileQueueViewController.h"

@interface SKViewController ()

@end

@implementation SKViewController

@synthesize upperView;
@synthesize bottomView;
@synthesize tabBarController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
    CGSize size = self.view.bounds.size;
  
  float my_width=self.view.bounds.size.width;

    //self.view = [[TouchTracker alloc] initWithFrame:self.view.frame];
    self.view = [[TouchTracker alloc] initWithFrame:self.view.frame andTarget:self action:@selector(showSharingView:)];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"desco_bg.png"]];

  // Upper Pullable View
  UpperStyledPullableView * upper_pullable_view = [[UpperStyledPullableView alloc]
                                       initWithFrame:CGRectMake(
                                                                0, 0, my_width,200)];
  //self.view.frame.size.width,
  //self.view.frame.size.height/7 )];
  upper_pullable_view.openedCenter = CGPointMake(my_width/2, 100);
  upper_pullable_view.closedCenter = CGPointMake(my_width/2, -65);
  upper_pullable_view.center = upper_pullable_view.closedCenter;
  
  //SKUserListViewController *user_list_view_controllor = [[SKUserListViewController alloc] initWithNibName:nil bundle:nil];
  
  //[upper_pullable_view addSubview:user_list_view_controllor.view];
  upperView = upper_pullable_view;
  
  [self.view addSubview:upper_pullable_view];


  
  StyledPullableView * pullable_vew = [[StyledPullableView alloc]
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
  
  
  SKStuffViewController *my_stuff_view_controllor = [[SKStuffViewController alloc] initWithNibName:nil bundle:nil];
  UIViewController *recent_view_controllor = [[UIViewController alloc] initWithNibName:nil bundle:nil];

  //[[my_stuff_view_controllor view] setBackgroundColor:[UIColor clearColor]];
  
  
  
  my_stuff_view_controllor.ng_tabBarItem =
    [NGTabBarItem itemWithTitle:@"My Stuffs" image:[UIImage imageNamed:@"Briefcase"]];
  recent_view_controllor.ng_tabBarItem =
  [NGTabBarItem itemWithTitle:@"Favorites" image:[UIImage imageNamed:@"Fevorite"]];

  [my_stuff_view_controllor.ng_tabBarItem setTitleColor:[UIColor lightGrayColor]];
  
  
  NSArray *viewController = [NSArray arrayWithObjects:my_stuff_view_controllor,recent_view_controllor,nil];
  
  tabBarController = [[NGTabBarController alloc] initWithDelegate:self];
  tabBarController.tabBar.backgroundColor=[UIColor clearColor];
  tabBarController.tabBarPosition = NGTabBarPositionTop;
  tabBarController.tabBar.drawItemHighlight = NO;
  tabBarController.tabBar.drawGloss = NO;
  tabBarController.tabBar.layoutStrategy = NGTabBarLayoutStrategyStrungTogether;
  tabBarController.tabBar.tintColor=[UIColor clearColor];
  tabBarController.tabBar.itemPadding=0.f;
  
  [self addChildViewController:tabBarController];
  tabBarController.viewControllers = viewController;
  
    [pullable_vew addSubview:tabBarController.view];
    
    // side buttons
    CGFloat buttonSize = 40.0f;
    CGFloat spaceSize = buttonSize + 10.0f;
    //UIBarButtonItem *fileQueueButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"side_file_queue.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(popupSideMenu:)];
    UIButton *fileQueueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *MessageButton   = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *SettingsButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fileQueueButton.frame = CGRectMake(size.width - spaceSize, size.height / 3.0f , buttonSize, buttonSize);
    MessageButton.frame   = CGRectMake(size.width - spaceSize, size.height / 3.0f + spaceSize, buttonSize, buttonSize);
    SettingsButton.frame  = CGRectMake(size.width - spaceSize, size.height / 3.0f + spaceSize * 2, buttonSize, buttonSize);
    [fileQueueButton setImage:[UIImage imageNamed:@"side_file_queue.png"] forState:UIControlStateNormal];
    [MessageButton   setImage:[UIImage imageNamed:@"side_message.png"]    forState:UIControlStateNormal];
    [SettingsButton  setImage:[UIImage imageNamed:@"side_settings.png"]   forState:UIControlStateNormal];
    [fileQueueButton addTarget:self action:@selector(popupFileQueueMenu:) forControlEvents:UIControlEventTouchUpInside];
    [MessageButton   addTarget:self action:@selector(showChatBoard:) forControlEvents:UIControlEventTouchUpInside];
    [SettingsButton  addTarget:self action:@selector(popupFileQueueMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fileQueueButton];
    [self.view addSubview:MessageButton];
    [self.view addSubview:SettingsButton];
}

- (void)showSharingView:(id)sender
{
    NSLog(@"showSharingView!!!");
}
  
- (void)popupFileQueueMenu:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (popover) {
        [popover dismissPopoverAnimated:YES];
    }
    
    UIViewController *controller = [[FileQueueViewController alloc] init];
    controller.contentSizeForViewInPopover = CGSizeMake(320.0f, 480.0f);
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    //[popover presentPopoverFromBarButtonItem:self permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    [popover presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}
  
- (void)showChatBoard:(id)sender
{
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"chat_board.png"]];
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
