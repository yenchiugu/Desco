//
//  SKStuffViewController.m
//  PullTest
//
//  Created by Sam Ku on 9/15/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SKStuffViewController.h"

#import "GMGridViewLayoutStrategies.h"
#import "UpperStyledPullableView.h"

#import "SKThumbnailImgUtils.h"
#import "SKImgLoadContext.h"

@interface SKStuffViewController () <
GMGridViewDataSource,GMGridViewSortingDelegate,GMGridViewTransformationDelegate,
UINavigationControllerDelegate,UIImagePickerControllerDelegate,
SKDoubleTapEvent

> {
    __gm_weak GMGridView *_gmGridView;

}


//- (void)computeViewFrames;
@end



@implementation SKStuffViewController

//@synthesize _gmGridView;
@synthesize bar = _bar;;
//@synthesize photo_btn;
@synthesize popover;
@synthesize tmp;
@synthesize selectedIdx;

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
    /*
    _doc_img_path = [[NSBundle mainBundle]pathForResource:@"Word" ofType:@"png"];
    _pdf_img_path = [[NSBundle mainBundle]pathForResource:@"Reader" ofType:@"png"];
    _jpg_img_path = [[NSBundle mainBundle]pathForResource:@"Jpg" ofType:@"png"];
    _mkv_img_path = [[NSBundle mainBundle]pathForResource:@"MKV" ofType:@"png"];
    _mpg_img_path = [[NSBundle mainBundle]pathForResource:@"MPG" ofType:@"png"];
    */
//    
//    UIImage *image = [UIImage imageNamed:@"file_toolbar_.png"];
//    UIImage *selectedImage = [UIImage imageNamed:@"file_toolbar_.png"];
//    UIImage *toggledImage = [UIImage imageNamed:@"file_toolbar_.png"];
//    UIImage *toggledSelectedImage = [UIImage imageNamed:@"file_toolbar_.png"];
//    CGPoint center = CGPointMake(40.0f, 40.0f);
    


    
    //NSArray *buttons = [NSArray arrayWithObjects:b1, nil];
    //_bar = [[RNExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:buttons center:center];
    
    //[_bar setHorizontal:YES];
    //[_bar setExplode:YES];
    //[[self view] addSubview:_bar];
    //[self setBar:_bar];
    
    CGRect grid_view_frame = CGRectMake(0, 45, self.view.bounds.size.width,
                                        self.view.bounds.size.height);
    GMGridView *gmGridView2 = [[GMGridView alloc] initWithFrame:grid_view_frame];
    gmGridView2.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    UIImage *photo_btn_image = [UIImage imageNamed:@"Metro-Photo-Blue.png"];
    
    CGRect buttonFrame = CGRectMake(5, 5, 70.0f, 30.0f);
    UIButton* photo_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [photo_btn setFrame:buttonFrame];
    [photo_btn setTitle:@"Photos" forState:UIControlStateNormal];
    photo_btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [photo_btn setImage:photo_btn_image forState:UIControlStateNormal];
    [photo_btn addTarget:self
                  action:@selector(photoBtnTouchUp:)
        forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    
    [[self view] addSubview:photo_btn];
    
    _gmGridView.sortingDelegate = self;
    //_gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.skDoubleTapDelegate = self;
    
    //UIView *view1 = self.parentViewController.view;
    UIView *view2 = self.parentViewController.view;
    //UIView *view3 = self.parentViewController.parentViewController.parentViewController.view;
    
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
    
    CGRect frame2 = CGRectMake(0, 45, self.view.bounds.size.width ,160);

    _gmGridView.frame = frame2;
}

#pragma mark button events
-(void) photoBtnTouchUp:(id)sender {
    //先設定sourceType為相機，然後判斷相機是否可用（ipod）沒相機，不可用將sourceType設定為相片庫
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    popover =
        [[UIPopoverController alloc] initWithContentViewController:picker];
    
    // TODO how to change default frame size?
    [popover presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:self.view
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    //[self presentModalViewController:picker animated:YES];
    
}

-(void) saveImage:(UIImage*) img {
    
    [SKThumbnailImgUtils saveImage:img];
    [_gmGridView reloadData];
}


#pragma mark –
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"didFinishPickingMediaWithInfo info:%@",info);
    
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.0];
    [popover dismissPopoverAnimated:YES];
    

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}



//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    
    return [SKThumbnailImgUtils getFileCount];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE)
    {
        return CGSizeMake(140, 110);
    }
    else
    {
        return CGSizeMake(140, 140);
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = nil;//[gridView dequeueReusableCell];
    
    NSString *filename;
    UIImage *thumbnail_img =
        [SKThumbnailImgUtils openOrCreateThumbnailImgFromIndex:index
                                                       ImgSize:size
                                                   outFileName:&filename];
    /*
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                       [self getDocPath]];
    
    int file_cnt = 0;
    //NSString *filepath;
    NSString *filename;
    UIImage *thumbnail_img;
    
    NSLog(@"cellForItemAtIndex index:%d",index);
    while (filename= [dir_enum nextObject]) {
        
        if ([[filename pathExtension] isEqualToString:@"png"] ||
            [[filename pathExtension] isEqualToString:@"jpg"] ) {
            if (index==file_cnt) {
                thumbnail_img =
                [self openOrCreateThumbnailImg:filename imgSize:size];
                
                NSLog(@"filename: %@", filename);
                break;
            }
            ++file_cnt;
        }
                
           
    }
    */
    
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height+20)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        CGFloat my_x = 0.0f;
        CGFloat my_y = 0.0f;
        if (thumbnail_img.size.width < size.width) {
            my_x = (size.width-thumbnail_img.size.width)/2;
        } else if (thumbnail_img.size.height < size.height) {
            my_y = (size.height-thumbnail_img.size.height)/2;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(my_x, my_y, size.width, size.height)];
        
        
        imageView.image = thumbnail_img;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 5;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0, 2);
        imageView.layer.shadowOpacity = 0.8;
        imageView.layer.shadowRadius = 2.0;
        imageView.clipsToBounds = NO;
//        if (index==0||index==1 ||index==5) {
//            imageView.image = [UIImage imageWithContentsOfFile:_jpg_img_path];
//            
//        } else if (index==2) {
//            imageView.image = [UIImage imageWithContentsOfFile:_doc_img_path];
//            
//        } else if (index==3 || index==4) {
//            imageView.image = [UIImage imageWithContentsOfFile:_pdf_img_path];
//            
//        } else if (index==6) {
//            imageView.image = [UIImage imageWithContentsOfFile:_mkv_img_path];
//            
//        } else if (index==7) {
//            imageView.image = [UIImage imageWithContentsOfFile:_mpg_img_path];
//            
//        } else{
//            imageView.image = [UIImage imageWithContentsOfFile:_jpg_img_path];
//            
//        }
        [imageView sizeToFit];
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
    NSString *str=filename;
//    if (index==0) {
//        str=@"民宿1_8044195d";
//    } else if(index==1) {
//        str=@"民宿2_3718011414_2e85c9efc3_o";
//    } else if (index==2) {
//        str=@"201109墾丁行程";
//    } else if (index==3) {
//        str=@"xUnit_Test_Patterns_Refactoring_Test_Code";
//    } else if (index==4) {
//        str=@"pcav";
//    } else if (index==5) {
//        str=@"QR share 12-9-10 12 33 53.jpg";
//    } else if (index==6) {
//        str=@"20111222";
//    } else if (index==7) {
//        str=@"20110310013";
//    } else if (index==8){
//        str=@"Smiler的秘密";
//    } else if (index==9){
//        str=@"Ace的生活";
//    } else if (index==10){
//        str=@"SamKu的一天";
//    }
    label.text = str;
    
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    
    //NSLog(@"%@,string:%@",label,str);
    label.tag = 500;
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
                         cell.contentView.backgroundColor = [UIColor clearColor];
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
                         cell.contentView.backgroundColor =  [UIColor clearColor];
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
                         //cell.contentView.backgroundColor = [UIColor orangeColor];
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

- (void)doubleClick:(GMGridView*) gridView atIndex:(NSInteger)index {
    NSLog(@"double click delegate");
    NSLog(@"%@",self.parentViewController);
    selectedIdx = index;
    [self.parentViewController
        performSegueWithIdentifier:@"ToolbarPhotoViewControllorSegue"
        sender:self];
    

}



@end
