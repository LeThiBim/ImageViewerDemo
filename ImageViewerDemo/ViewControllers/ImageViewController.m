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

#define IMAGE_WIDTH         [[UIScreen mainScreen] applicationFrame].size.width
#define IMAGE_HEIGHT        480

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) NSMutableArray* imageList;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

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
    
    [self loadImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SOME FUNCTIONS TO HANDLE ROTATE EVENT

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
   
   // CGRect bounds = [UIScreen mainScreen].bounds;
   // self.scrollView.bounds = bounds;
    
    [self loadImages];
}



- (void) loadImages
{

    self.imageList = [[NSMutableArray alloc] init];
    
    float generalScaledHeight = [[UIScreen mainScreen] applicationFrame].size.height - 64 - 25;
    float generalScaledWidth  = IMAGE_WIDTH;

    
    for (int i = 0; i < [self.albumSource.imageList count]; i++)
    {
        UIImageView* imageView;
        
        if ([self.albumSource checkIfWidthGreaterThanHeightAtIndexPath:i])
        {
            float scaledHeight = [self.albumSource getScaledHeightOfImageAtIndexPath:i];

            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*IMAGE_WIDTH, 0, generalScaledWidth, scaledHeight)];
            
        }
        else
        {
            float scaledWidth = [self.albumSource getScaledWidthOfImageWithScaledHeight:generalScaledWidth AtIndexPath:i];
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*IMAGE_WIDTH + (IMAGE_WIDTH - scaledWidth)/2, 0, scaledWidth, generalScaledHeight)];
        }
        
        [imageView setImageWithURL:[self.albumSource getLargeImageURLOfIndex:i] placeholderImage:[UIImage imageNamed:@"media_app.png"]];
        
  
        [self.scrollView addSubview:imageView];
        
        [self.imageList addObject:imageView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(IMAGE_WIDTH*[self.albumSource.imageList count], generalScaledHeight)];
    [self.scrollView setContentOffset:CGPointMake(IMAGE_WIDTH*self.currentImageIndex, 0) animated:YES];
    [self.scrollView setPagingEnabled:YES];

}


@end
