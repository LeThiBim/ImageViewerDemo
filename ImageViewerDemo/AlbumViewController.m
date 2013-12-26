//
//  ViewController.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/19/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumViewController.h"
#import "Cell.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ImageViewController.h"

//NSString *kCellID = @"cellID";

@interface AlbumViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //
    //    [[AFAppDotNetAPIClient sharedClient] GET:@"api/post"
    //                                  parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
    //    {
    //
    //        NSLog(@" DATA : %@", JSON);
    //
    //    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
    //
    //    }];
    
    // __weak ViewController *weakSelf = self;
    
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        
    }];
    
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        
    }];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    //   [self.collectionView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.getAlbumSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        cell.label.textColor = [UIColor grayColor];

    }
    
    //NSString *imageIdentifier = [self.dataSource identifierForIndexPath:indexPath];
    NSString *text = [self.getAlbumSource getTitleOfIndex:indexPath.row];
    cell.label.text = text;
    [cell.image setImageWithURL:[self.getAlbumSource getImageURLOfIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"media_app.png"]];
    
    [cell scheduleMoveTitle];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ImageViewer"])
    {
      //  NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
                                     
        ImageViewController *imageViewController = [segue destinationViewController];
        imageViewController.imageList = self.getAlbumSource.imageList;
        //imageViewController.currentImage = selectedIndexPath.row;
        
        
              
    }
}


#pragma mark - DataSource delegate

- (void) finishGetImageLinksFromServer
{
    [self.collectionView reloadData];
}


@end
