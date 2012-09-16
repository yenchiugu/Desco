//
//  StuffViewController.h
//  PullTest
//
//  Created by Sam Ku on 9/14/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface StuffViewController : UIViewController<AQGridViewDelegate, AQGridViewDataSource> {
  NSArray *_demo_items;
  NSString *_doc_img_path;
}
@property ( strong) AQGridView * gridView;
@end
