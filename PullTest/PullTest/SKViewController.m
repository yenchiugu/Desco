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
#import "SideMenu/ChatBoardView.h"

#import "MJPopupViewController/UIViewController+MJPopupViewController.h"
#import "QuestionSendViewController.h"
#import "FriendRequestViewController.h"

@interface SKViewController ()
{
    TouchTracker *touchTracker;
    FileQueueViewController *fileQueueMenu;
    UIPopoverController *fileQueuePopover;
    UIView *sharingMenu;
    ChatBoardView *chatBoard;
}

@end


@implementation SKViewController

@synthesize upperView;
@synthesize bottomView;
@synthesize tabBarController;
@synthesize questionSendViewController;
@synthesize locationShareButton;
@synthesize qrCodeShareButton;
@synthesize locationViewController;
@synthesize qrCodeViewController;
@synthesize locationSearchViewController;
@synthesize friendRequestViewController;
//@synthesize mapView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
    CGFloat my_width  = self.view.bounds.size.width;
    CGFloat my_height = self.view.bounds.size.height;

    // setup background
    //self.view = [[TouchTracker alloc] initWithFrame:self.view.frame];
    touchTracker = [[TouchTracker alloc] initWithFrame:self.view.frame andTarget:self action:@selector(showGestureMenu:)];
    touchTracker.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"desco_bg.png"]];
    self.view = touchTracker;
    
    // setup chat board
    chatBoard = [[ChatBoardView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:chatBoard];

    // Upper Pullable View
    UpperStyledPullableView * upper_pullable_view = [[UpperStyledPullableView alloc]
                                       initWithFrame:CGRectMake(
                                                                0, 0, my_width, 200)];
    //self.view.frame.size.width,
    //self.view.frame.size.height/7 )];
    upper_pullable_view.openedCenter = CGPointMake(my_width/2, 100);
    upper_pullable_view.closedCenter = CGPointMake(my_width/2, -65);
    upper_pullable_view.center = upper_pullable_view.closedCenter;

    //SKUserListViewController *user_list_view_controllor = [[SKUserListViewController alloc] initWithNibName:nil bundle:nil];

    //[upper_pullable_view addSubview:user_list_view_controllor.view];
    upperView = upper_pullable_view;
    [upperView setTag:2377]; // <----
    [self.view addSubview:upper_pullable_view];



    StyledPullableView *pullable_view = [[StyledPullableView alloc]
                                 initWithFrame:CGRectMake(0, 0, my_width, 500)];
                                   //self.view.frame.size.width,
                                   //self.view.frame.size.height/7 )];
    pullable_view.openedCenter = CGPointMake(my_width/2, my_height+50);
    pullable_view.closedCenter = CGPointMake(my_width/2, my_height+230);
    pullable_view.center = pullable_view.closedCenter;
    pullable_view.handleView.frame = CGRectMake(0, 0, my_width, 20);
    pullable_view.handleView.backgroundColor = [UIColor whiteColor];
    pullable_view.backgroundColor = [UIColor whiteColor];
    pullable_view.delegate = self;

    bottomView = pullable_view;
    [self.view addSubview:pullable_view];


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
    tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    tabBarController.tabBarPosition = NGTabBarPositionTop;
    tabBarController.tabBar.drawItemHighlight = NO;
    tabBarController.tabBar.drawGloss = NO;
    tabBarController.tabBar.layoutStrategy = NGTabBarLayoutStrategyStrungTogether;
    tabBarController.tabBar.tintColor = [UIColor clearColor];
    tabBarController.tabBar.itemPadding = 0.0f;

    [self addChildViewController:tabBarController];
    tabBarController.viewControllers = viewController;
  
    [pullable_view addSubview:tabBarController.view];
    
    [self setupSideButtons];
    [self setupSharingMenu];
    [self setupFriendAddingMenu];
  
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    questionSendViewController = (QuestionSendViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"QuestionSendViewControllor"];
    //UIViewController *mainViewControllor = [self viewController];
  
    questionSendViewController.delegate = self;
    [questionSendViewController.view setFrame:CGRectMake(0, 0, 256, 128)];
}

- (void)setupSideButtons
{
    CGSize mySize = self.view.bounds.size;
    CGFloat buttonSize = 40.0f;
    CGFloat spaceSize = buttonSize + 10.0f;
    //UIBarButtonItem *fileQueueButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"side_file_queue.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(popupSideMenu:)];
    UIButton *fileQueueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *MessageButton   = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *SettingsButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fileQueueButton.frame = CGRectMake(mySize.width - spaceSize, mySize.height / 3.0f , buttonSize, buttonSize);
    MessageButton.frame   = CGRectMake(mySize.width - spaceSize, mySize.height / 3.0f + spaceSize, buttonSize, buttonSize);
    SettingsButton.frame  = CGRectMake(mySize.width - spaceSize, mySize.height / 3.0f + spaceSize * 2, buttonSize, buttonSize);
    [fileQueueButton setImage:[UIImage imageNamed:@"side_file_queue.png"] forState:UIControlStateNormal];
//    [MessageButton   setImage:[UIImage imageNamed:@"side_message_light.png"]    forState:UIControlStateNormal];
    [MessageButton   setImage:[UIImage imageNamed:@"side_message.png"]    forState:UIControlStateNormal];
    [SettingsButton  setImage:[UIImage imageNamed:@"side_settings.png"]   forState:UIControlStateNormal];
    [fileQueueButton addTarget:self action:@selector(popupFileQueueMenu:) forControlEvents:UIControlEventTouchUpInside];
    [MessageButton   addTarget:self action:@selector(showChatBoard:)      forControlEvents:UIControlEventTouchUpInside];
    [SettingsButton  addTarget:self action:@selector(popupFileQueueMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fileQueueButton];
    [self.view addSubview:MessageButton];
    [self.view addSubview:SettingsButton];
}

- (void)setupSharingMenu
{
    sharingMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600+30, 422+20)];
    sharingMenu.center = self.view.center;
    //sharingMenu.backgroundColor = [UIColor whiteColor];
    sharingMenu.alpha = 0;
    locationShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qrCodeShareButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *locationSearchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    locationShareButton.frame = CGRectMake(10, 10, 300, 300);
    qrCodeShareButton.frame   = CGRectMake(320, 10, 300, 300);
    // 126x102
    locationSearchButton.frame = CGRectMake(247, 320, 126, 102);
    locationShareButton.backgroundColor = [UIColor whiteColor];
    qrCodeShareButton.backgroundColor   = [UIColor whiteColor];
    locationSearchButton.backgroundColor = [UIColor whiteColor];
    [locationShareButton setImage:[UIImage imageNamed:@"gestureLocationShare.png"] forState:UIControlStateNormal];
    [qrCodeShareButton   setImage:[UIImage imageNamed:@"gestureQRCodeShare.png"]   forState:UIControlStateNormal];
    [locationSearchButton setImage:[UIImage imageNamed:@"SearchLocation-01.png"] forState:UIControlStateNormal];
    [locationSearchButton   addTarget:self action:@selector(clickLocationSearchBtn:)      forControlEvents:UIControlEventTouchUpInside];
    
    [sharingMenu addSubview:locationShareButton];
    [sharingMenu addSubview:qrCodeShareButton];
    [sharingMenu addSubview:locationSearchButton];
    [self.view addSubview:sharingMenu];
}

- (void)setupFriendAddingMenu
{
}

- (void)showGestureMenu:(id)sender
{
    TouchTracker *tracker = (TouchTracker *) sender;
    if (tracker.letter[0] == 'S') {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0f];
        sharingMenu.alpha = 1;
        [UIView commitAnimations];
    } else if (tracker.letter[0] == 'O') {
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
      [self setFriendRequestViewController:(FriendRequestViewController *)
                                          [storyboard instantiateViewControllerWithIdentifier:@"FriendRequestViewController"]];
      
      static int people = 1;
      [self.friendRequestViewController.view setFrame:CGRectMake(0, 0, 500, 496)];

      if (people==1) {
        [self.friendRequestViewController.imgView setImage:[UIImage imageNamed:@"user02.jpg"]];
        [self.friendRequestViewController.friendLable setText:@"SY"];
        people =2;
      } else {
        [self.friendRequestViewController.imgView setImage:[UIImage imageNamed:@"user01.jpg"]];
                [self.friendRequestViewController.friendLable setText:@"Ace"];
        people = 1;
      }
      
      //[mainViewControllor.qrCodeViewController setMainView:mainViewControllor];
      [self.friendRequestViewController setDelegate:self];
      [self presentPopupViewController:self.friendRequestViewController animationType:MJPopupViewAnimationSlideBottomTop];
       // NSLog(@"showFriendAddingView!!!");

    }
}
  
- (void)popupFileQueueMenu:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (fileQueuePopover == nil) {
        UIViewController *controller = [[FileQueueViewController alloc] init];
        controller.contentSizeForViewInPopover = CGSizeMake(240.0f, 480.0f);
        fileQueuePopover = [[UIPopoverController alloc] initWithContentViewController:controller];
    }

    if (fileQueuePopover.popoverVisible) {
        [fileQueuePopover dismissPopoverAnimated:YES];
    } else {
        [fileQueuePopover presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}
  
- (void)showChatBoard:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button setImage:[UIImage imageNamed:@"side_message.png"] forState:UIControlStateNormal];
    bool is_showing = chatBoard.alpha < 0.5f;
    touchTracker.enabled = !is_showing;
    CGFloat newAlpha = is_showing ? 1.0f : 0.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    chatBoard.alpha = newAlpha;
    [UIView commitAnimations];
}

- (void)clickLocationSearchBtn:(id)sender
{
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  [self setLocationSearchViewController:(LocationSearchViewController *) 
   [storyboard instantiateViewControllerWithIdentifier:@"LocationSearchViewController"]];
  
  [self.locationSearchViewController.view setFrame:CGRectMake(0, 0, 500, 570)];
  
  //[mainViewControllor.qrCodeViewController setMainView:mainViewControllor];
  [self.locationSearchViewController setDelegate:self];
  [self presentPopupViewController:self.locationSearchViewController animationType:MJPopupViewAnimationSlideBottomTop];
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

- (void)ClickSendYesBtn:(UIViewController*) uiview {
  [self dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];
  
}

- (void)ClickSendNoBtn:(UIViewController*) uiview {
  [self dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];
  
}

- (void)ClickShareNowBtn:(UIViewController*) uiview {
  
  [self dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.1f];
  sharingMenu.alpha = 0;
  [UIView commitAnimations];
  [self setLocationViewController:nil];
}

- (void)ClickCancelBtn:(UIViewController*) uiview {
  [self dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.1f];
  sharingMenu.alpha = 0;
  [UIView commitAnimations];
  [self setLocationViewController:nil];
}

- (void)ClickDesktopDescoBtn:(UIViewController*) uiview {
  [self dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.1f];
  sharingMenu.alpha = 0;
  [UIView commitAnimations];
}

- (void)ClickSaveBtn:(UIViewController*) uiview {
  [self dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.1f];
  sharingMenu.alpha = 0;
  [UIView commitAnimations];
  [self setLocationSearchViewController:nil];
}

- (void)ClickAcceptBtn:(UIViewController*) uiview {
  [self dismissPopupViewControllerWithanimationType: MJPopupViewAnimationSlideBottomTop];

  [self setFriendRequestViewController:nil];
}
@end
