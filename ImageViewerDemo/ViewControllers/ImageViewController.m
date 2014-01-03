//
//  ImageViewController.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/23/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageViewController.h"
#import "UIImageView+WebCache.h"


@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) NSMutableArray* imageList;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) UIImageView* imageView1;
@property (strong, nonatomic) UIImageView* imageView2;
@property (strong, nonatomic) UIImageView* imageView3;

@property (assign, nonatomic) BOOL  isDisableScrollView;
@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
 
    self.scrollView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.scrollView setDelegate:self];
    
    self.toolBar.translucent = YES;
    
    [self loadImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.toolbar.translucent = YES;
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
}

#pragma mark - SOME FUNCTIONS TO HANDLE ROTATE EVENT

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
   
    CGRect frame;
    
    self.isDisableScrollView = YES;
      [self.scrollView setScrollEnabled:NO];
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }
    else
    {
        frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
    
    self.scrollView.frame = frame;
    
   
    for (int i = 0; i < [self.imageList count]; i++)
    {
        UIImageView* imageView = (UIImageView*) [self.imageList objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    
    [self.imageList removeAllObjects];
    
    [self loadImages];
 
}



- (void) loadImages
{

    float generalScaledWidth  = self.scrollView.frame.size.width;
    float generalScaledHeight = self.scrollView.frame.size.height;
    
    
    if (!self.imageList)
    {
        self.imageList = [[NSMutableArray alloc] init];
    }

 
    for (int i = 0; i < [self.albumSource.imageList count]; i++)
    {
        UIImageView* imageView;
        
        CGSize suitableSize = [self.albumSource getSuitableScaledSizeOfItemAtIndex:i FromGeneralScaledWith:generalScaledWidth AndGeneralScaledHeight:generalScaledHeight];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*generalScaledWidth + (generalScaledWidth - suitableSize.width)/2, 0, suitableSize.width, suitableSize.height)];
        
        
        [imageView setImageWithURL:[self.albumSource getLargeImageURLOfIndex:i] placeholderImage:[UIImage imageNamed:@"media_app.png"]];


        [self.scrollView addSubview:imageView];

        [self.imageList addObject:imageView];
    }
    

    [self.scrollView setContentSize:CGSizeMake(generalScaledWidth*[self.albumSource.imageList count], generalScaledHeight)];
    [self.scrollView setContentOffset:CGPointMake(generalScaledWidth*self.currentImageIndex, 0) animated:YES];
    [self.scrollView setPagingEnabled:YES];

    [self.scrollView setScrollEnabled:YES];
    
    self.isDisableScrollView = NO;

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!self.isDisableScrollView)
    {
    
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (page != self.currentImageIndex)
        {
            self.currentImageIndex = page;
        }
    }

}


@end
