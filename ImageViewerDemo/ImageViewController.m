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

#define IMAGE_WIDTH         320
#define IMAGE_HEIGHT        480

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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

- (void) loadImages
{
    for (int i = 0; i < [self.imageList count]; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*IMAGE_WIDTH, 480 - 568, IMAGE_WIDTH, IMAGE_HEIGHT)];
        
        NSDictionary* item = (NSDictionary*) [self.imageList objectAtIndex:i];
        NSString* imageLink = [item objectForKey:@"image"];
        NSURL *imageURL = [NSURL URLWithString:imageLink];
        
        NSLog(@"IMAGE URL : %@", imageLink);
        
        [imgView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"media_app.png"]];
        
         NSLog(@"ImageView Y : %f", imgView.frame.origin.y);
        
        [self.scrollView addSubview:imgView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(IMAGE_WIDTH*[self.imageList count], IMAGE_HEIGHT)];
    //[self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self.scrollView setPagingEnabled:YES];

}


@end
