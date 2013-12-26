//
//  ViewController.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/19/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "Cell.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "AlbumViewController.h"

NSString *kCellID = @"cellID";

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

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
    return [self.dataSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        cell.label.textColor = [UIColor grayColor];
        //cell.label.textAlignment = NSTextAlignmentCenter;
    }
    
    //NSString *imageIdentifier = [self.dataSource identifierForIndexPath:indexPath];
    NSString *text = [self.dataSource getTitleOfIndex:indexPath.row];
    cell.label.text = text;
    [cell.image setImageWithURL:[self.dataSource getImageURLOfIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"media_app.png"]];
    
    [cell scheduleMoveTitle];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"showAlbum"])
    {
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        NSString *albumId = [self.dataSource getAlbumId:selectedIndexPath.row];

        
        AlbumViewController *albumViewController = [segue destinationViewController];
        albumViewController.getAlbumSource = [[GetAlbumSource alloc] init];
        albumViewController.getAlbumSource.delegate = albumViewController;
        albumViewController.getAlbumSource.albumId = albumId;
        [albumViewController.getAlbumSource getImageLinksFromServer];
        
    }
}


#pragma mark - DataSource delegate

- (void) finishGetImageLinksFromServer
{
    [self.collectionView reloadData];
}


@end
