//
//  YourAlbumViewController.m
//  ImageViewerDemo
//
//  Created by HuyNguyenQuang on 1/13/14.
//  Copyright (c) 2014 HuyNguyenQuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YourAlbumViewController.h"
#import "Cell.h"
#import "UIImageView+WebCache.h"
#import "DataService.h"
#import "IMAGE.h"
#import "CustomBackgroundView.h"

#import "MFSideMenu.h"


@interface YourAlbumViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray* photos;

@property (strong, nonatomic) NSArray* yourAlbum;

@end

@implementation YourAlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.yourAlbum = [[DataService sharedInstance] selectAllByContext];

    self.collectionView.backgroundView = [[CustomBackgroundView alloc] init];

}

- (void) viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MSBarButtonIconNavigationPane.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(navigationPaneRevealBarButtonItemTapped:)];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;

    self.yourAlbum = [[DataService sharedInstance] selectAllByContext];
    [self.collectionView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    if (self.yourAlbum)
        return [self.yourAlbum count];
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        cell.label.textColor = [UIColor grayColor];
        
    }
    
    cell.tag = indexPath.row;
    
    IMAGE* image = (IMAGE*) [self.yourAlbum objectAtIndex:indexPath.row];
    
    NSString *text = image.imageId;
    cell.label.text = text;
    
    NSString* filePath = image.imagePath;
    
    if (image.thumbPath)
        filePath = image.thumbPath;
        
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:filePath];
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SELECT ITEM AT INDEX PATH : %ld", (long) indexPath.row);
    
    // Create array of MWPhoto objects
    self.photos = [NSMutableArray array];
    //[self.photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]]]];
    
    for (int i = 0; i < [self.yourAlbum count]; i++)
    {
        IMAGE* image = (IMAGE*) [self.yourAlbum objectAtIndex:i];
        
        MWPhoto* photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:image.imagePath]];
        photo.photoId = image.imageId;
        
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

- (void)navigationPaneRevealBarButtonItemTapped:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
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
