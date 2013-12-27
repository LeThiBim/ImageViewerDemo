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


@interface AlbumViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	   
    [self.collectionView addPullToRefreshWithActionHandler:^{
        
        //TODO: reload data
        
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
    return [self.albumSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        cell.label.textColor = [UIColor grayColor];

    }
    
    NSString *text = [self.albumSource getTitleOfIndex:indexPath.row];
    cell.label.text = text;
    [cell.image setImageWithURL:[self.albumSource getImageURLOfIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"media_app.png"]];
    
    [cell scheduleMoveTitle];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ImageViewer"])
    {
        ImageViewController *imageViewController = [segue destinationViewController];
        imageViewController.imageList = self.albumSource.imageList;
    }
}


#pragma mark - DataSource delegate

- (void) finishGetImageLinksFromServer
{
    [self.collectionView reloadData];
}


@end
