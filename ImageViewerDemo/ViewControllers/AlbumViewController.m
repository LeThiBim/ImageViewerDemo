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
@property (strong, nonatomic) NSMutableArray* photos;

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
    
    cell.tag = indexPath.row;
    
    NSString *text = [self.albumSource getTitleOfIndex:indexPath.row];
    cell.label.text = text;
    [cell.image setImageWithURL:[self.albumSource getThumbImageURLOfIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"media_app.png"]];
    
    [cell scheduleMoveTitle];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ImageViewer"])
    {
        ImageViewController *imageViewController = [segue destinationViewController];
        imageViewController.albumSource = self.albumSource;
        
        UICollectionViewCell* selectedCell = (UICollectionViewCell*) sender;
        imageViewController.currentImageIndex = selectedCell.tag;
    }
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SELECT ITEM AT INDEX PATH : %ld", (long) indexPath.row);
    
    // Create array of MWPhoto objects
    self.photos = [NSMutableArray array];
    //[self.photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]]]];
    
    for (int i = 0; i < [self.albumSource.imageList count]; i++)
    {
        MWPhoto* photo = [MWPhoto photoWithURL:[self.albumSource getLargeImageURLOfIndex:i]];
        photo.photoId = [self.albumSource getTitleOfIndex:i];
        
        [self.photos addObject:photo];
    }
    
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.wantsFullScreenLayout = YES; // iOS 5 & 6 only: Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
    
    
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:indexPath.row];
    
}


#pragma mark - DataSource delegate

- (void) finishGetImageLinksFromServer
{
    if (self.collectionView)
    {
        [self.collectionView reloadData];
    }
}


#pragma mark - MWPhotoBrowser delegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}


@end
