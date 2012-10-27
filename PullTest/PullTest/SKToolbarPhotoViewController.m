//
//  SKToolbarPhotoViewController.m
//  PullTest
//
//  Created by Sam Ku on 12/10/26.
//  Copyright (c) 2012年 Sam Ku. All rights reserved.
//

#import "SKToolbarPhotoViewController.h"
#import "SKThumbnailImgUtils.h"
#import "SKImgLoadContext.h"
#import "CaptionedPhotoView.h"
@interface SKToolbarPhotoViewController () {
    NSOperationQueue *op_queue;
}

@end

@implementation SKToolbarPhotoViewController

@synthesize my_navigationController;
@synthesize select_index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)loadView {
    [super loadView];
    op_queue = [NSOperationQueue new];
    self.photoAlbumView.dataSource = self;
    self.photoScrubberView.dataSource = self;
    
    // This title will be displayed until we get the results back for the album information.
    self.title = NSLocalizedString(@"Loading...", @"Navigation bar title - Loading a photo album");
    [self.photoAlbumView reloadData];
    [self.photoScrubberView reloadData];

    
    
    [self.photoScrubberView setSelectedPhotoIndex:select_index];
    [self.photoAlbumView moveToPageAtIndex:
        self.photoScrubberView.selectedPhotoIndex animated:NO];
    
    [self refreshChromeState];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.my_navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self.my_navigationController setNavigationBarHidden:YES animated:YES];
    }
    [super viewWillDisappear:animated];
}




- (void)loadImgToAlbum:(SKImgLoadContext*) cxt {
    NSFileManager *file_mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                       [SKThumbnailImgUtils getDocPath]];
    
    int file_cnt = 0;
    //NSString *filepath;
    NSString *filename;
    //UIImage *thumbnail_img;
    
    //NSLog(@"cellForItemAtIndex index:%d",index);
    while (filename= [dir_enum nextObject]) {
        
        if ([[filename pathExtension] isEqualToString:@"png"] ||
            [[filename pathExtension] isEqualToString:@"jpg"] ) {
            if (cxt.index==file_cnt) {
                
                
                NSString *filepath = [[SKThumbnailImgUtils getDocPath]
                                      stringByAppendingPathComponent:filename];
                
                UIImage *img = [UIImage imageWithContentsOfFile:filepath];
                
                [self.photoAlbumView didLoadPhoto:img
                                        atIndex:cxt.index
                                        photoSize:
                                        NIPhotoScrollViewPhotoSizeOriginal];
                NSLog(@"loadImgToAlbum DONE! filepath: %@", filepath);
                
                return;
            }
            ++file_cnt;
        }
    }
}

- (NSInteger)numberOfPagesInPagingScrollView:(NIPhotoAlbumScrollView *)photoScrollView {
    return [SKThumbnailImgUtils getFileCount];
}

#pragma mark NIPhotoAlbumScrollViewDataSourceDelegate
- (UIImage *)photoAlbumScrollView: (NIPhotoAlbumScrollView *)photoAlbumScrollView
                     photoAtIndex: (NSInteger)photoIndex
                        photoSize: (NIPhotoScrollViewPhotoSize *)photoSize
                        isLoading: (BOOL *)isLoading
          originalPhotoDimensions: (CGSize *)originalPhotoDimensions {
    
    SKImgLoadContext *context= [[SKImgLoadContext alloc] initWithIndex:photoIndex];
    NSInvocationOperation *op = [[NSInvocationOperation alloc]
                                 initWithTarget:self
                                 selector:@selector(loadImgToAlbum:)
                                 object:context];
    [op_queue addOperation:op];
    
    *isLoading = YES;
    *photoSize = NIPhotoScrollViewPhotoSizeThumbnail;
    NSString* filename;
    return [SKThumbnailImgUtils openThumbnailImgFromIndex:photoIndex
                                              outFileName:&filename];
    
}

- (UIView<NIPagingScrollViewPage>*)pagingScrollView:
                            (NIPagingScrollView *)pagingScrollView
                            pageViewForIndex:(NSInteger)pageIndex {
    // TODO (jverkoey Nov 27, 2011): We should make this sort of custom logic easier to build.
    UIView<NIPagingScrollViewPage>* pageView = nil;
    NSString* reuseIdentifier = NSStringFromClass([CaptionedPhotoView class]);
    pageView = [pagingScrollView dequeueReusablePageWithIdentifier:reuseIdentifier];
    if (nil == pageView) {
        pageView = [[CaptionedPhotoView alloc] init];
        pageView.reuseIdentifier = reuseIdentifier;
    }
    
    NIPhotoScrollView* photoScrollView = (NIPhotoScrollView *)pageView;
    photoScrollView.photoScrollViewDelegate = self.photoAlbumView;
    photoScrollView.zoomingAboveOriginalSizeIsEnabled = [self.photoAlbumView isZoomingAboveOriginalSizeEnabled];
    
    CaptionedPhotoView* captionedView = (CaptionedPhotoView *)pageView;
    NSString *filename;
    [SKThumbnailImgUtils openThumbnailImgFromIndex:pageIndex outFileName:&filename];
    captionedView.caption = filename;
    
    return pageView;
}

#pragma mark Fetching Required Information /** @name Fetching Required Information */

- (NSInteger)numberOfPhotosInScrubberView:(NIPhotoScrubberView *)photoScrubberView {
    return [SKThumbnailImgUtils getFileCount];
}

- (UIImage *)photoScrubberView: (NIPhotoScrubberView *)photoScrubberView
              thumbnailAtIndex: (NSInteger)thumbnailIndex{
    NSString *filename;
    return [SKThumbnailImgUtils openThumbnailImgFromIndex:thumbnailIndex
                                              outFileName:&filename];
}
@end
