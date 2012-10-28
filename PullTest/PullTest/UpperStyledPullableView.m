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
#import "MJPopupViewController/UIViewController+MJPopupViewController.h"
#import "QuestionSendViewController.h"

#import "SKViewController.h"
#import "TopMenu/AvatarMenuViewController.h"

#import "SKFriendProfileUtils.h"

@interface UpperStyledPullableView ()
{
    NSArray *user_image_paths;
    __gm_weak GMGridView *_gmGridView;
    GMGridViewCell *_animatedCell;
    UIPopoverController *avatarPopover;
}
@end

@implementation UpperStyledPullableView

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mybarbarupbk.png"]];
        imgView.frame = CGRectMake(0, 0, frame.size.width, 200);
        [self addSubview:imgView];
        
        user_image_paths = [NSArray arrayWithObjects:
                            [[NSBundle mainBundle] pathForResource:@"user01" ofType:@"jpg"],
                            [[NSBundle mainBundle] pathForResource:@"user06" ofType:@"jpg"],
                            [[NSBundle mainBundle] pathForResource:@"user08" ofType:@"jpg"],
                            
                            [[NSBundle mainBundle] pathForResource:@"user03" ofType:@"jpg"],
                            [[NSBundle mainBundle] pathForResource:@"user09" ofType:@"jpg"],
                            [[NSBundle mainBundle] pathForResource:@"user04" ofType:@"jpg"],
                            [[NSBundle mainBundle] pathForResource:@"user05" ofType:@"jpg"],
                            [[NSBundle mainBundle] pathForResource:@"user07" ofType:@"jpg"],
                            
                            [[NSBundle mainBundle] pathForResource:@"user10" ofType:@"jpg"],
                            [[NSBundle mainBundle] pathForResource:@"user02" ofType:@"jpg"],
                            nil];
        
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
        _gmGridView.actionDelegate = self;
    }
    
    _animatedCell = NULL;
    return self;
}


#pragma mark - Privates
- (void)computeViewFrames
{
    CGRect frame2 = CGRectMake(0, 0, self.bounds.size.width ,180);
    _gmGridView.frame = frame2;
}



//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
  return [SKFriendProfileUtils getProfileCount];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE) {
        return CGSizeMake(140, 110);
    } else {
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
    
    NSString *tmp_profile_path = [user_image_paths objectAtIndex:index];

    imageView.image = [SKFriendProfileUtils openProfileImgFromIndex:index outFileName:&tmp_profile_path];
    
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,size.height,size.width,20)];//cell.contentView.bounds];
    //label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //
    label.text = [tmp_profile_path stringByDeletingPathExtension];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    if (avatarPopover == nil) {
        AvatarMenuViewController *controller = [[AvatarMenuViewController alloc] init];
        controller.contentSizeForViewInPopover = CGSizeMake(200.0f, 135.0f);
        avatarPopover = [[UIPopoverController alloc] initWithContentViewController:controller];
    }
    
    if (avatarPopover.popoverVisible) {
        [avatarPopover dismissPopoverAnimated:YES];
    } else {
        GMGridViewCell *cell = [_gmGridView cellForItemAtIndex:position];
        //CGRect newFrame = [self.superview convertRect:cell.frame fromView:cell];
        [avatarPopover presentPopoverFromRect:cell.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void)draggingEvent:(CGPoint)pt sourceView:(UIView *)srcView
{
    CGPoint converted_p = [srcView convertPoint:pt toView:_gmGridView];
    NSLog(@"converted: [%f,%f]", converted_p.x, converted_p.y);
    //UIView *target=[_gmGridView hitTest:converted_p withEvent:nil];
    int position = [_gmGridView.layoutStrategy itemPositionFromLocation:converted_p];
    
    NSLog(@"positoin:%d",position);
    //NSLog(@"target:%@",target);
    
    if (position != -1) {
        //CGPoint converted_p2 =[self convertPoint:converted_p toView:target];
        
        //UIView *target2=[target hitTest:converted_p2 withEvent:nil];
        //NSLog(@"target2:%@",target2);
        //int position = [_gmGridView.layoutStrategy itemPositionFromLocation:converted_p];
        GMGridViewCell *cell = [_gmGridView cellForItemAtIndex:position];
        if (_animatedCell != cell) {
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
            [UIView animateWithDuration:0.1 delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:(void (^)(void)) ^ {
                                 cell.transform=CGAffineTransformMakeScale(1.2, 1.2);}
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

- (void)droppedEvent:(CGPoint) pt sourceView:(UIView *)srcView sourceText:(NSString *)text{
    NSLog(@"[droppedEvent] sourceText:%@",text);
    
    CGPoint localtion_pt = [srcView convertPoint:pt toView:mainViewControllor.locationShareButton];
    BOOL dropped_to_location = [mainViewControllor.locationShareButton pointInside:localtion_pt withEvent:nil];
    NSLog(@"pointInside [location]:%d", dropped_to_location);
    
    if (dropped_to_location) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        [mainViewControllor setLocationViewController: (LocationShareViewController*)
        [storyboard instantiateViewControllerWithIdentifier:@"LocationShareViewController"]];
        [mainViewControllor.locationViewController.view setFrame:CGRectMake(0, 0, 500, 570)];
        //[mainViewControllor.locationViewController showCurrentLocation];
        [mainViewControllor.locationViewController setMainView:mainViewControllor];
        [mainViewControllor.locationViewController setDelegate:mainViewControllor];
        [mainViewControllor presentPopupViewController:mainViewControllor.locationViewController animationType:MJPopupViewAnimationSlideBottomTop];
        return;
    }
    
    CGPoint qrcode_pt = [srcView convertPoint:pt toView:mainViewControllor.qrCodeShareButton];
    BOOL dropped_to_qrcode = [mainViewControllor.qrCodeShareButton pointInside:qrcode_pt withEvent:nil];
    NSLog(@"pointInside [location]:%d", dropped_to_qrcode);
    
    if (dropped_to_qrcode) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        [mainViewControllor setQrCodeViewController: (QrCodeShareViewController*)
        [storyboard instantiateViewControllerWithIdentifier:@"QrCodeShareViewController"]];
        [mainViewControllor.qrCodeViewController.view setFrame:CGRectMake(0, 0, 500, 570)];
        
        //[mainViewControllor.qrCodeViewController setMainView:mainViewControllor];
        [mainViewControllor.qrCodeViewController setDelegate:mainViewControllor];
        [mainViewControllor presentPopupViewController:mainViewControllor.qrCodeViewController animationType:MJPopupViewAnimationSlideBottomTop];
        return;
    }
    
    
    CGPoint converted_p =[srcView convertPoint:pt toView:_gmGridView];
    NSLog(@"converted: [%f,%f]",converted_p.x,converted_p.y);
    UIView *target=[_gmGridView hitTest:converted_p withEvent:nil];
    int position = [_gmGridView.layoutStrategy itemPositionFromLocation:converted_p];
    
    NSLog(@"positoin:%d",position);
    NSLog(@"target:%@",target);
    
    if (position != -1) {
        //GMGridViewCell *cell = [_gmGridView cellForItemAtIndex:position];
        SKViewController *mainViewControllor = (SKViewController*)[self viewController];
        mainViewControllor.questionSendViewController.toUser = @"test";
        mainViewControllor.questionSendViewController.srcFile = @"/var/mobile/Applications/BD1C2E94-FE81-4473-9098-5F6050216035/Documents/img_20122810114427.png";
        [mainViewControllor.questionSendViewController.view setFrame:CGRectMake(0, 0, 400, 250)];
        [mainViewControllor presentPopupViewController:mainViewControllor.questionSendViewController animationType:MJPopupViewAnimationSlideBottomTop];
    }
    
    if (_animatedCell) {
        [UIView animateWithDuration:0 delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^ {_animatedCell.transform = CGAffineTransformIdentity;}
                         completion:nil
         ];
        _animatedCell = NULL;
    }
}

@end
