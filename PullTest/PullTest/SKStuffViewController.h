//
//  SKStuffViewController.h
//  PullTest
//
//  Created by Sam Ku on 9/15/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNExpandingButtonBar/RNExpandingButtonBar.h"
#import "GMGridView.h"

@interface SKStuffViewController : UIViewController {
  NSString *_doc_img_path;
  NSString *_pdf_img_path;
  NSString *_jpg_img_path;
  NSString *_mkv_img_path;
  NSString *_mpg_img_path;
  RNExpandingButtonBar *_bar;
//  GMGridView *_gmGridView;
}

@property (nonatomic, strong) RNExpandingButtonBar *bar;
@property (nonatomic, strong) UIPopoverController  *popover;
//@property (nonatomic, strong) GMGridView *_gmGridView;
//@property (nonatomic, strong) UIButton *photo_btn;
@property (nonatomic,strong) UIImage *tmp;
@end
