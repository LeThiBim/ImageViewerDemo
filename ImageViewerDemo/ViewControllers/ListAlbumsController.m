//
//  ViewController.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 12/19/13.
//  Copyright (c) 2013 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListAlbumsController.h"
#import "Cell.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "AlbumViewController.h"
#import "CustomCollectionViewLayout.h"


@interface ListAlbumsController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ListAlbumsController

- (void) adjustContentInsetForLegacy {
    self.collectionView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    typeof (&*self) __weak weakSelf = self;
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        
        //TODO: reload data
        [weakSelf.dataSource getImageLinksFromServer];
        
    }];
    
    self.collectionView.collectionViewLayout = [[CustomCollectionViewLayout alloc] init];

}

- (void) viewDidAppear:(BOOL)animated
{

    [self updateLayout];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
    [self updateLayout];
    
}

- (void) updateLayout
{
    CustomCollectionViewLayout* layout = (CustomCollectionViewLayout*) self.collectionView.collectionViewLayout;
    
    layout.contentSizeWith  = self.collectionView.bounds.size.width;
    layout.columnCount      = self.collectionView.bounds.size.width/150;
    
    [layout invalidateLayout];
    
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
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        cell.label.textColor = [UIColor grayColor];
    }
    
    
    NSString *text = [self.dataSource getTitleOfIndex:indexPath.row];
    cell.label.text = text;
    
    [cell.image setImageWithURL:[self.dataSource getImageURLOfIndex:indexPath.row]
               placeholderImage:[UIImage imageNamed:@"media_app.png"]];
    
    [cell scheduleMoveTitle];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"showAlbum"])
    {
        NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        NSString *albumId = [self.dataSource getAlbumId:selectedIndexPath.row];

        
        AlbumViewController *albumViewController = [segue destinationViewController];
        albumViewController.albumSource = [[AlbumSource alloc] init];
        albumViewController.albumSource.delegate = albumViewController;
        albumViewController.albumSource.albumId = albumId;
        [albumViewController.albumSource getImageLinksFromServer];
        
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}


#pragma mark - DataSource delegate

- (void) finishGetImageLinksFromServer
{
    if (self.collectionView)
    {
        [self.collectionView reloadData];
        [self.collectionView.pullToRefreshView stopAnimating];
    }
    
}


@end
