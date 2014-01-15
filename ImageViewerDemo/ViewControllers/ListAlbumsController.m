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
#import "NSObject+Utilities.h"

@interface ListAlbumsController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UITextView* noDataTextView;

@end

@implementation ListAlbumsController

- (void) adjustContentInsetForLegacy {
    self.collectionView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    typeof (&*self) __weak weakSelf = self;
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        
        //TODO: reload data
        [weakSelf.dataSource getImageLinksFromServer];
        
    }];
    
}

- (void) dealloc
{
    self.dataSource.delegate = nil;
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}



- (void) viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:YES];
    
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MSBarButtonIconNavigationPane.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(navigationPaneRevealBarButtonItemTapped:)];

    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    //UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Grid" style:UIBarButtonItemStyleBordered target:self action:@selector(displayButtonTapped)];
    
    UIButton* listGridButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 38)];;
    
    if ([NSObject getConstraintWidthForAlbumCell] == 150)
        [listGridButton setImage:[UIImage imageNamed:@"grid-white.png"] forState:UIControlStateNormal];
    else
        [listGridButton setImage:[UIImage imageNamed:@"list-white.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:listGridButton];
    
    [listGridButton addTarget:self action:@selector(displayButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
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
    layout.columnCount      = self.collectionView.bounds.size.width/[NSObject getConstraintWidthForAlbumCell];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    UIButton* listGridButton = (UIButton*) self.navigationItem.rightBarButtonItem.customView;
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        [listGridButton setFrame:CGRectMake(listGridButton.frame.origin.x, listGridButton.frame.origin.y, 25, 25)];
        
        if ([NSObject getConstraintWidthForAlbumCell] == 240)
            layout.columnCount = 1;
    }
    else
    {
        [listGridButton setFrame:CGRectMake(listGridButton.frame.origin.x, listGridButton.frame.origin.y, 39, 38)];
    }

    
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
    
    [cell setConstraintForImageView];
    
    NSString *text = [self.dataSource getTitleOfIndex:indexPath.row];
    cell.label.text = text;
    
    [cell.imageView setImageWithURL:[self.dataSource getImageURLOfIndex:indexPath.row]
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

- (void)navigationPaneRevealBarButtonItemTapped:(id)sender
{
    [self.navigationPaneViewController setPaneState:MSNavigationPaneStateOpen animated:YES completion:nil];
}

- (void) setUpCustomLayOut
{
    if (self.collectionView)
    {
        self.collectionView.collectionViewLayout = [[CustomCollectionViewLayout alloc] initWithDataSource:self.dataSource];

        [self updateLayout];
    }
}

- (void) displayButtonTapped
{
    UIButton* listGridButton = (UIButton*) self.navigationItem.rightBarButtonItem.customView;
    
    if ([NSObject getConstraintWidthForAlbumCell] == 150)
    {
        [NSObject setConstraintWidthForAlbumCellWithValue:240];
        [listGridButton setImage:[UIImage imageNamed:@"list-white.png"] forState:UIControlStateNormal];
    }
    else
    {
        [NSObject setConstraintWidthForAlbumCellWithValue:150];
        [listGridButton setImage:[UIImage imageNamed:@"grid-white.png"] forState:UIControlStateNormal];
    }
    
    [self updateLayout];
    [self.collectionView reloadData];
}

#pragma mark - DataSource delegate

- (void) finishGetImageLinksFromServerSuccessful
{
    if (self.collectionView)
    {
        if (self.noDataTextView && [self.dataSource.imageList count] >0)
            [self.noDataTextView setHidden:YES];
        
        
        CustomCollectionViewLayout* customCollectionViewLayout = (CustomCollectionViewLayout*) self.collectionView.collectionViewLayout;
        
        customCollectionViewLayout.listAlbumSource = self.dataSource;
        
        [self.collectionView reloadData];
        [self.collectionView.pullToRefreshView stopAnimating];
    }
    
}

- (void) finishGetImageLinksFromServerFailed
{
    if (self.collectionView)
    {
        [self.collectionView.pullToRefreshView stopAnimating];
        
        if (!self.noDataTextView && [self.dataSource.imageList count] == 0)
        {
            self.noDataTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, [NSObject getScreenWidthForOrientation], ([NSObject getScreenHeightForOrientation] - 100)/2 )];
            [self.noDataTextView setBackgroundColor:[UIColor blackColor]];
            [self.noDataTextView setTextColor:[UIColor whiteColor]];
            [self.noDataTextView setTextAlignment:NSTextAlignmentCenter];
        
            self.noDataTextView.text = NSLocalizedString(@"EMPTY_CONTENT_TEXT", nil);
            
            [self.view addSubview:self.noDataTextView];
            
        }
        
    }
}

@end
